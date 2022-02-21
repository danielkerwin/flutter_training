import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class PlacesDatabase {
  static const name = 'places.db';
  static const placesTable = 'user_places';
  static const createStatement =
      'CREATE TABLE $placesTable(id TEXT PRIMARY KEY, title TEXT, image TEXT)';
}

typedef DatabaseResult = List<Map<String, dynamic>>;

class DatabaseService {
  static Future<sql.Database> getDatabase(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, PlacesDatabase.name),
      onCreate: (db, version) {
        return db.execute(PlacesDatabase.createStatement);
      },
      version: 1,
    );
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseService.getDatabase(table);
    return db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<DatabaseResult> query(String table) async {
    final db = await DatabaseService.getDatabase(table);
    return db.query(table);
  }

  static Future<DatabaseResult> queryById(String table, String id) async {
    final db = await DatabaseService.getDatabase(table);
    return db.query(table, where: 'id = ?', whereArgs: [id]);
  }
}
