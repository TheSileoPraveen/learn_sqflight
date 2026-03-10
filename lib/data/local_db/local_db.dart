import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  LocalDb._();

  static final localDb = LocalDb._();
  static final String tableName = "note";
  static final String idColumn = "note_id";
  static final String titleColumn = "note_title";
  static final String descColumn = "note_desc";
  static final String createdByColumn = "created_by";

  Database? myDb;

  Future<Database> getDb() async {
    if (myDb != null) {
      return myDb!;
    } else {
      myDb = await openDb();
      return myDb!;
    }
  }

  Future<Database> openDb() async {
    Directory dbDir = await getApplicationDocumentsDirectory();

    String path = join(dbDir.path, "notes.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $tableName ($idColumn integer primary key autoincrement, $titleColumn text, $descColumn text, $createdByColumn text)",
        );
      },
    );
  }

  Future<int> insertNote({required Map<String, dynamic> rows}) async {
    final db = await getDb();
    return await db.insert(tableName, rows);
  }

  Future<List<Map<String, dynamic>>> getAllNote() async {
    final db = await getDb();
    return await db.query(tableName);
  }

  Future<int> updateNote({
    required Map<String, dynamic> row,
    required int id,
  }) async {
    final db = await getDb();
    return await db.update(
      tableName,
      row,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteNote({required int id}) async {
    final db = await getDb();
    return await db.delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
  }
}
