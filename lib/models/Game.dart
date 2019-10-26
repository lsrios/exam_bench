import 'package:exam_bench/models/Subject.dart';
import 'package:sqflite/sqflite.dart';

class Game {
  final int id;
  final String name;
//  final List<Subject> subjects;

//  Game({this.id, this.name, this.subjects});
  Game({this.id, this.name});

  Game.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
