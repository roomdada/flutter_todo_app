import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, intversion) {
      return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY, task TEXT, done INTEGER )");
    });
  }

  static Future<int> create(String task) async {
    final db = await getDatabase();
    return db.insert('todos', {'task': task, 'done': 0});
  }
}
