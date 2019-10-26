class User {
  final String id;
  final String name;
  final int globalScore;

  User({this.id, this.name, this.globalScore});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        globalScore = json['globalScore'];
}
