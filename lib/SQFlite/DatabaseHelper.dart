import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Playlist.db";

  static Future<Database> _getDBForTable(String tableName) async {
    return openDatabase(join(await getDatabasesPath(), _dbName));
  }

  static Future<Database> _getDB(String tableName) async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE $tableName(_id TEXT PRIMARY KEY, musicFilePath TEXT NOT NULL, title TEXT NOT NULL, singers TEXT NOT NULL, movie TEXT NOT NULL, actors TEXT NOT NULL);"),
        version: _version);
  }

  static Future createDB(String tableName) async {
    Database db = await _getDBForTable(tableName);
    await db.execute("CREATE TABLE $tableName(_id TEXT PRIMARY KEY, musicFilePath TEXT NOT NULL, title TEXT NOT NULL, singers TEXT NOT NULL, movie TEXT NOT NULL, actors TEXT NOT NULL);");
  }

  static Future deleteDB(String tableName) async {
    Database db = await _getDBForTable(tableName);
    await db.execute("DROP TABLE IF EXISTS $tableName");
  }

  static Future<int> addSong(SQFlitePlaylistDataClass sqFlitePlaylistDataClass, String tableName) async {
    final db = await _getDB(tableName);
    return await db.insert(tableName, sqFlitePlaylistDataClass.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteSong(SQFlitePlaylistDataClass sqFlitePlaylistDataClass, String tableName) async {
    final db = await _getDB(tableName);
    return await db.delete(
      tableName,
      where: '_id = ?',
      whereArgs: [sqFlitePlaylistDataClass.sId],
    );
  }

  static Future<List<SQFlitePlaylistDataClass>?> getAllSongs(String tableName) async {
    final db = await _getDB(tableName);
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => SQFlitePlaylistDataClass.fromJson(maps[index]));
  }

  static Future<List<String>> getTables(String tableName) async {
    final db = await _getDBForTable(tableName);
    var tableNames = (
        await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false);
    return tableNames;
  }

}