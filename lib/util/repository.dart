import 'package:exam_bench/models/Game.dart';
import 'package:exam_bench/models/User.dart';
import 'package:exam_bench/util/database_helper.dart';

class Repository {
  static Future<List<Game>> get allGames async {
    final sql = 'select * from game';
    List<Game> gameList = [];
    final data = await db.rawQuery(sql);

    data.forEach((row) {
      final game = Game.fromJson(row);
      gameList.add(game);
    });

    return gameList;
  }

  static Future<Game> getGame(int id) async {
    final sql = 'select * from game g where g.id = $id';
    final data = await db.rawQuery(sql);

    return Game.fromJson(data[0]);
  }

  static Future<int> getGlobalScore() async {
    final sql = 'select globalScore from user';
    final data = await db.rawQuery(sql);

    if (data.isEmpty) {
      return 0;
    }
    return data[0]['globalScore'] ?? 0;
  }

  static Future<String> getUserName() async {
    final sql = 'select name from user';
    final data = await db.rawQuery(sql);

    if (data.isEmpty) {
      return '';
    }
    return data[0]['name'];
  }

  static Future<Map<String, int>> getSubjects() async {
    final sql = 'select name, score from subject';
    final data = await db.rawQuery(sql);
    final subjects = <String, int>{};

    if (data.isEmpty) {
      return {};
    }

    data.forEach((it) {
      subjects[it['name']] = it['score'];
    });

    return subjects;
  }

  static Future<Map<String, int>> getSubject(String subject) async {
    final sql = 'select name, score from subject where name = $subject';
    List<Map<String, dynamic>> data;
    try {
      data = await db.rawQuery(sql);
    } on Exception {
      return {};
    }

    return data[0];
  }

  static Future<void> addGame(Game game) async {
    final sql = '''insert into game(name) 
    values (${game.name})''';

    final result = await db.rawInsert(sql);
    DatabaseHelper.databaseLog('addGame', sql, null, result);
  }

  static Future<void> addUser(User user) async {
    final sql = '''insert into user(name, globalScore) 
    values (${user.name}, ${user.globalScore})''';

//    final result = await db.rawInsert(sql);
    final result = await db
        .insert('user', {'name': user.name, 'globalScore': user.globalScore});
    DatabaseHelper.databaseLog('addUser', sql, null, result);
  }

//  static Future<void> deleteGame(Game game) async {}

  // function template
  static Future<void> updateScores(String subject, int score) async {
    final sqlGlobalScore = 'update user set globalScore = globalScore + $score';
    String sqlSubjectScore =
        'update subject set score = score + $score where name = \"$subject\"';

    if ((await getSubject(subject)).isEmpty) {
      await db.insert('subject', {'name': subject, 'score': 0});
    }

    var result = await db.rawUpdate(sqlGlobalScore);
    DatabaseHelper.databaseLog(
        'update globalScore', sqlGlobalScore, null, result);
    result = await db.rawUpdate(sqlSubjectScore);
    DatabaseHelper.databaseLog(
        'update subjectScore', sqlSubjectScore, null, result);
  }
}
