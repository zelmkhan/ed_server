import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/postgres_commands.dart';
import '../../models/payload.dart';
import '../../security/validation.dart';

Future<Response> pokeHandler(Request request) async {
  var payload = Payload.fromJson(request.url.queryParameters);
  
  // if (!validation(payload.validationStructure(), payload.hash)) {
  //   print('Data not from Telegram app');
  //   return Response.unauthorized('Data not from Telegram app');
  // }

  var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

  var user = await PostgresCommands.getUser(username: payload.user.username);
  print(payload.ref);
  if (user == null) {
    var createUser;
    
    if (payload.ref != null) {
      createUser = await PostgresCommands.createAccount(username: payload.user.username, lastEntry: timestamp);
      var ref = await PostgresCommands.getUser(username: payload.ref!);
      await PostgresCommands.pokeIn(username: payload.ref!, days: ref['days'] + 1, lastEntry: ref['last_entry']);
    } else {
      createUser = await PostgresCommands.createAccount(username: payload.user.username, lastEntry: timestamp);
    }
    
    if (createUser) {
      return Response.ok(json.encode({'success': {
        'days': 1,
        'last_entry': timestamp
      }}));
    } else {
      return Response.ok(json.encode({'error': 'User not created'}));
    }
  }

  var lastEntry = user['last_entry'];
  if (lastEntry + 86400 > timestamp) {
    return Response.ok(json.encode({'success': {
      'days': user['days'],
      'last_entry': user['last_entry']
    }}));
  }

  if (lastEntry + 172800 <= timestamp) {
    await PostgresCommands.pokeIn(username: payload.user.username, days: 1, lastEntry: timestamp);
      return Response.ok(json.encode({'success': {
      'days': 1,
      'last_entry': timestamp
    }}));
  }

  var daysCounter = user['days'] + 1;
  var pockIn = await PostgresCommands.pokeIn(username: payload.user.username, days: daysCounter, lastEntry: timestamp);

  if (!pockIn) {
    return Response.ok(json.encode({'error': 'Error when updating the day counter'}));
  }

  return Response.ok(json.encode({'success': {
    'days': daysCounter,
    'last_entry': timestamp
  }}));
}