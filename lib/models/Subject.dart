class Subject {
  final int id;
//  final int gameId;
  final String name;
  final int score;

//  Subject(this.id, this.gameId, this.name, this.score);
  Subject({this.id, this.name, this.score});

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        score = json['score'];
}
