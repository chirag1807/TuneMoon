import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tunemoon/SQFlite/SQFlitePlaylistDataClass.dart';

class DatabaseHelperRecentPlay{
  static const int _version = 1;
  static const String _dbName = "RecentPlaylist.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE recentPlaylist(_id TEXT PRIMARY KEY, musicFilePath TEXT NOT NULL, title TEXT NOT NULL, singers TEXT NOT NULL, movie TEXT NOT NULL, actors TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addSong(SQFlitePlaylistDataClass sqFlitePlaylistDataClass) async {
    final db = await _getDB();
    return await db.insert("recentPlaylist", sqFlitePlaylistDataClass.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteSong(SQFlitePlaylistDataClass sqFlitePlaylistDataClass) async {
    final db = await _getDB();
    return await db.delete(
      "recentPlaylist",
      where: '_id = ?',
      whereArgs: [sqFlitePlaylistDataClass.sId],
    );
  }

  static Future<int> deleteBulkSong(List<String> sIds) async {
    final db = await _getDB();
    return await db.delete(
      "recentPlaylist",
        where: '_id IN (${List.filled(sIds.length, '?').join(',')})',
        whereArgs: sIds
    );
  }

  static Future<List?> getAllSongs() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("recentPlaylist");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => SQFlitePlaylistDataClass.fromJson(maps[index]));
  }

}