import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_bench/screens/game_screen.dart';
import 'package:exam_bench/util/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exam_bench/constants.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Firestore _firestore = Firestore.instance;
  List<String> _subjects;
  bool _isFetching = true;
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    dbHelper.fetchPlayScreenData().then((result) {
      setState(() {
        _subjects = result;
        _isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: _isFetching ? _loading : _buildSubjectList,
    );
  }

  Widget get _buildSubjectList {
    return ListView(
      children: <Widget>[
        for (String subject in _subjects)
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  // TODO mudar o esquema do jogo aqui
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
//                      gameName: 'enem',
//                      gameDifficult: GameDifficult.easy,
                      gamePath: 'games/enem/2018/$subject',
                      subject: subject,
                    ),
                  ),
                );
              },
              title: Text('Enem'),
              subtitle: Text(
                subject,
                style: TextStyle(color: Colors.blueGrey[400]),
              ),
            ),
          ),
      ],
    );
  }

  Widget get _loading {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
