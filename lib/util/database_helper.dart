import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

Database db; // ver se eu tiro daqui

class DatabaseHelper {
  Firestore _firestore = Firestore.instance;
//  Database db; // ver se eu tiro daqui
  static const gameTable = 'game';
  static const subjectTable = 'subject';
  static const userTable = 'user';
//  static const id = 'id';
//  static const name = 'name';
//  static const info = 'info';
//  static const isDeleted = 'isDeleted';

  static void databaseLog(
    String functionName,
    String sql, [
    List<Map<String, dynamic>> selectQueryResult,
    int insertAndUpdateQueryResult,
  ]) {
    print(functionName);
    print(sql);
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<void> createGameTable(Database db) async {
    final gameSql = '''create table $gameTable
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )''';

    await db.execute(gameSql);
  }

  Future<void> createSubjectTable(Database db) async {
//    final subjectSql = '''create table $subjectTable
//    (
//      id INTEGER PRIMARY KEY AUTOINCREMENT,
//      name TEXT,
//      score INTEGER,
//      gameID INTEGER,
//      FOREIGN KEY(gameID) REFERENCES game(id)
//    )''';

    final subjectSql = '''create table $subjectTable
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      score INTEGER
    )''';

    await db.execute(subjectSql);
  }

  Future<void> createUserTable(Database db) async {
    final userSql = '''create table $userTable
    (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      globalScore INTEGER
    )''';

    await db.execute(userSql);
  }

  Future<String> getDatabasePath(String dbName) async {
//    final databasePath = await getDatabasesPath();
    final directory = await getApplicationDocumentsDirectory();
//    final path = join(databasePath, dbName);
    final path = directory.path + dbName;

//    if (await Directory(dirname(path)).exists()) {
//      await deleteDatabase(path);
//      await Directory(dirname(path)).create(recursive: true);
//    } else {
//      await Directory(dirname(path)).create(recursive: true);
//    }

    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath('exambench_db');
    db = await openDatabase(path,
        version: 1, onCreate: handleCreate, readOnly: false);
//    db = await openDatabase(path, version: 1);
    print(db);
  }

  Future<void> handleCreate(Database db, int version) async {
    await createGameTable(db);
    await createSubjectTable(db);
    await createUserTable(db);
  }

  Future<List<String>> fetchPlayScreenData() async {
    List<String> subjects = [];
    var query = await _firestore.collection('games/enem/2018').getDocuments();
    query.documents.forEach((document) => subjects.add(document.documentID));
    return subjects;
  }
}
