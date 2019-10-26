import 'package:exam_bench/models/User.dart';
import 'package:exam_bench/util/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:exam_bench/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exam_bench/util/repository.dart';

// TODO: Mudar o avatar do cara
class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  DatabaseHelper dbHelper;
  bool _isDataReady = false;
  FirebaseUser _user;
  String _userName = '';
  int _userGlobalScore = 0;
//  Map<String, int> _userGamesScore = {
//    'Português': 200,
//    'Matemática': 340,
//    'Geografia': -100,
//    'Artes': 100,
//  };
  Map<String, int> _userGamesScore = {};

  List<Widget> _buildGameScoreRows() {
    List<Row> rowsList = [];
    _userGamesScore.forEach(
      (k, v) => rowsList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.sortUp,
              color: Colors.blue[200],
            ),
            Container(
              constraints: BoxConstraints(minWidth: 160.0),
              decoration: BoxDecoration(color: Colors.deepPurple[400]),
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                '$k: $v',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );

    return rowsList;
  }

  Future<String> _showRegisterAlert() async {
    String nickname;
    await Alert(
        context: context,
        title: "Registro",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Nickname',
              ),
//              onChanged: (value) => nickname = value,
              onChanged: (value) => nickname = value,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Salvar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();

    return nickname;
  }

  // Old version
//  Future<void> _fetchUserData() async {
//    _user = await FirebaseAuth.instance.currentUser();
//    DocumentReference documentReference =
//        Firestore.instance.collection('users').document(_user.uid);
//    DocumentSnapshot documentSnapshot = await documentReference.get();
//
//    if (documentSnapshot.data == null) {
//      _userName = await _showRegisterAlert();
//      documentReference.setData(
//        {
//          'name': _userName,
//          'globalScore': 0,
//          'games': [],
//        },
//      );
//    } else {
//      var userData = documentSnapshot.data;
//      _userName = userData['name'];
//      _userGlobalScore = userData['globalScore'];
//
//      CollectionReference leaderboardCollection =
//          Firestore.instance.collection('leaderboards');
//
//      for (String game in userData['games']) {
//        var query = await leaderboardCollection
//            .document(game)
//            .collection('classification')
//            .where('username', isEqualTo: _userName)
//            .getDocuments();
//
//        _userGamesScore[game] = query.documents.first.data['userScore'];
//      }
//    }
//
//    setState(() {});
//  }

  Future<void> _fetchUserData() async {
    _user = await FirebaseAuth.instance.currentUser();
    await dbHelper.initDatabase();

    _userGlobalScore = await Repository.getGlobalScore();
    _userName = await Repository.getUserName();
    _userGamesScore = await Repository.getSubjects();

    if (_userName.isEmpty) {
      _userName = await _showRegisterAlert();
      Repository.addUser(User(name: _userName, globalScore: _userGlobalScore));
    }
//      documentReference.setData(
//        {
//          'name': _userName,
//          'globalScore': 0,
//          'games': [],
//        },
//      );
//    } else {
//      var userData = documentSnapshot.data;
//      _userName = userData['name'];
//      _userGlobalScore = userData['globalScore'];
//
//      CollectionReference leaderboardCollection =
//          Firestore.instance.collection('leaderboards');
//
//      for (String game in userData['games']) {
//        var query = await leaderboardCollection
//            .document(game)
//            .collection('classification')
//            .where('username', isEqualTo: _userName)
//            .getDocuments();
//
//        _userGamesScore[game] = query.documents.first.data['userScore'];
//      }
//    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();

    if (_isDataReady) return;
    _fetchUserData().then((value) {
      setState(() {
        _isDataReady = !_isDataReady;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var child = _isDataReady ? _screenContent : _loadScreen;

    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: child,
    );
  }

  Widget get _screenContent => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            child: ClipOval(
              child: Image.network(
                'https://www.w3schools.com/howto/img_avatar.png',
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            _userName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber[400],
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '$_userGlobalScore pontos',
//                '540 pontos',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Position',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ..._buildGameScoreRows(),
        ],
      );

  Widget get _loadScreen => Padding(
        padding: EdgeInsets.all(double.infinity),
        child: CircularProgressIndicator(),
      );
}
