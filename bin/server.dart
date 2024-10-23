import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import '../bin/database/postgres_commands.dart';
import 'server/handlers/poke_handler.dart';


void main() async {
  await PostgresCommands.initDb();

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_ORIGIN: '*',
    'Content-Type': 'application/json;charset=utf-8'
  };

  var route = Router();

  route.get('/', (_) => Response.ok('ED © 2024'));

  route.get('/poke', pokeHandler);


  var handler = const Pipeline()
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(route.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  
  await serve(handler, '0.0.0.0', port).then((server) => print('Serving at http://${server.address.host}:${server.port}'));
}