import 'package:postgres/postgres.dart';

class DataBase {
  String host = 'localhost';
  int port = 5432;
  String database = 'postgres';
  String username = 'postgres';
  String password = 'qweasd';
  void connect() async {
    var connection = PostgreSQLConnection(host, port, database,
        username: username, password: password);
    await connection.open();
  }
}
