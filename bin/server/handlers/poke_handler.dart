import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../database/postgres_commands.dart';
import '../../models/payload.dart';
import '../../utils/validation.dart';

Future<Response> pokeHandler(Request request) async {
  var payload = Payload.fromJson(request.url.queryParameters);
  
  if (!validation(payload.validationStructure(), payload.hash)) {
    return Response.unauthorized('Data not from Telegram app');
  }

  var timestamp = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

  var user = await PostgresCommands.getUser(username: payload.user.username);

  if (user == null) {
    var createUser = await PostgresCommands.createAccount(username: payload.user.username, lastEntry: timestamp);
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
  if (lastEntry + 86400 < timestamp) {
    return Response.ok(json.encode({'error': 'Come back later'}));
  }

  var daysCounter = user['last_entry'] + 1;
  var pockIn = await PostgresCommands.pokeIn(username: payload.user.username, days: daysCounter, lastEntry: timestamp);

  if (!pockIn) {
    return Response.ok(json.encode({'error': 'Error when updating the day counter'}));
  }

  return Response.ok(json.encode({'success': {
    'days': daysCounter,
    'last_entry': timestamp
  }}));
}