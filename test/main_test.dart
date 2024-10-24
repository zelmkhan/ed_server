import 'package:test/test.dart';
import '../bin/database/postgres_commands.dart';


void main() {

  
  test('init_db', () async {
    await PostgresCommands.initDb();
  });


  test('create account', () async {
    var response = await PostgresCommands.createAccount(username: 'zelmkhan', lastEntry: 1);
    print(response);
  });


  test('get user', () async {
    var response = await PostgresCommands.getUser(username: 'zelmkhan');
    print(response);
  });

  test('pock in', () async {
    var response = await PostgresCommands.pokeIn(username: 'zelmkhan', days: 1, lastEntry: 1729687777);
    print(response);
  });

}
