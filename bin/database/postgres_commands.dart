import 'package:postgres/postgres.dart';

class PostgresCommands {
  static Future<Connection> getConnection() async {
    final connection = await Connection.open(
      Endpoint(
        host: 'c3l5o0rb2a6o4l.cluster-czz5s0kz4scl.eu-west-1.rds.amazonaws.com',
        database: 'do2v4f4vqb9p',
        username: 'ud3tfbrc0874gj',
        password: 'p5ce618054c4df92d0513c79e1fbc53fc07f9b6d61f67e31483e8ea315ad00756',
      ),
      settings: ConnectionSettings(sslMode: SslMode.require),
    );
    return connection;
  }

  static Future<void> initDb() async {
    final conn = await getConnection();
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS users (
        username TEXT PRIMARY KEY,
        days INTEGER NOT NULL,
        last_entry INTEGER NOT NULL,
        wallet TEXT
      );
    ''');
    await conn.close();
  }

  // ------------------------------------------------------------------------------------------------------------------------------------------------------------

  static Future createAccount({required String username, required int lastEntry}) async {
    final conn = await PostgresCommands.getConnection();

    try {
      await conn.execute(
          Sql.named(
              'INSERT INTO users (username, days, last_entry, wallet) VALUES (@username, @days, @last_entry, @wallet) ON CONFLICT (username) DO NOTHING'),
          parameters: {
            'username': username,
            'days': 1,
            'last_entry': lastEntry,
            'wallet': null
          });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      await conn.close();
    }
  }

  // ------------------------------------------------------------------------------------------------------------------------------------------------------------

  static Future getUser({required String username}) async {
    final conn = await PostgresCommands.getConnection();
    try {
      final user = await conn.execute(
          Sql.named('SELECT * FROM users WHERE username = @username'),
          parameters: {'username': username});

      return user.first.toColumnMap();
    } catch (_) {
      return null;
    } finally {
      await conn.close();
    }
  }

  // ------------------------------------------------------------------------------------------------------------------------------------------------------------

  static Future<bool> pokeIn({required String username, required int days, required int lastEntry}) async {
    final conn = await PostgresCommands.getConnection();
    try {
      await conn.execute(
          Sql.named('UPDATE users SET days = @days, last_entry = @last_entry WHERE username = @username'),
          parameters: {
            'username': username, 
            'days': days,
            'last_entry': lastEntry
            });
      return true;
    } catch (_) {
      return false;
    } finally {
      await conn.close();
    }
  }

}
  // ------------------------------------------------------------------------------------------------------------------------------------------------------------
