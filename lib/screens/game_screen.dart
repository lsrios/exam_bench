import 'package:exam_bench/screens/game_result_screen.dart';
import 'package:exam_bench/util/repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:exam_bench/constants.dart';
import 'package:exam_bench/widgets/answer_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:exam_bench/util/quiz_brain.dart';

class GameScreen extends StatefulWidget {
//  final String _gameName;
//  final GameDifficult _gameDifficult;
  final String _gamePath;
  final String _subject;

//  GameScreen({gameName, gameDifficult})
//      : _gameName = gameName,
//        _gameDifficult = gameDifficult;

  GameScreen({String gamePath, String subject})
      : _gamePath = gamePath,
        _subject = subject;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  QuizBrain _quizBrain;
  bool _gameReady = false;
  Question _question;
  List<int> _answersValues = [0, 0, 0, 0, 0];

  void _handlePress(int i) {
    setState(() {
      switch (_answersValues[i]) {
        case 0:
          _answersValues[i] = 1;
          break;
        case 1:
          _answersValues[i] = 2;
          break;
        case 2:
          _answersValues[i] = 1;
          break;
      }
    });
  }

//  void _quitScreen() => Navigator.pop(context);
  void _quitScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return GameResultScreen(_quizBrain);
        },
      ),
    );
  }

  void _handleNextPress() {
    if (_answersValues.where((it) => it == 2).toList().length > 1) {
      Alert(
        context: context,
        title: "Múltiplas respostas selecionadas",
        type: AlertType.error,
        desc: "Por favor selecione apenas uma alternativa",
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            onPressed: () => Navigator.pop(
              context,
            ),
          ),
        ],
      ).show();
      return;
    }

    _quizBrain.checkAnswer(_answersValues.indexOf(2));

    if (_quizBrain.isFinished) {
      Alert(
        context: context,
        title: "Game over",
        desc: "Sua pontuação foi ${_quizBrain.gameScore}",
        buttons: [
          DialogButton(
              child: Text(
                'Quit',
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                );
                _quitScreen();
              }),
        ],
      ).show();

//      FirebaseAuth.instance.currentUser().then(
//        (user) {
//          Firestore.instance.collection('users').document(user.uid).updateData(
//              {'globalScore': FieldValue.increment(_quizBrain.gameScore)});
//        },
//      );
      return;
    }
    setState(
      () {
        _question = _quizBrain.nextQuestion;
        _answersValues = _answersValues.map((it) => 0).toList();
      },
    );
  }

  List<AnswerButton> _buildAnswerButtons() {
    final List<AnswerButton> answerButtonList = [];

    for (int i = 0; i < 5; ++i) {
      answerButtonList.add(
        AnswerButton(
          answer: _answersValues[i],
          onPress: () => _handlePress(i),
          child: Text(_question.answers[i]),
        ),
      );
    }

    return answerButtonList;
  }

//  bool _checkAnswer() {
//    int chosenAnswer;
//
//    _answersValues.asMap().forEach((index, value) {
//      if (value == true) {
//        if (chosenAnswer == null) {
//          chosenAnswer = index;
//        } else {
//          print("mais de uma selecionada");
//          chosenAnswer = -1;
//        }
//      }
//    });
//
//    return chosenAnswer == correctAnswer;
//  }

  @override
  void initState() {
    super.initState();

//    _quizBrain = QuizBrain(
//        gameName: widget._gameName, gameDifficult: widget._gameDifficult);
    _quizBrain = QuizBrain(gamePath: widget._gamePath);

    _quizBrain.loadGame().then((value) {
      setState(() {
        _gameReady = !_gameReady;
        _question = _quizBrain.firstQuestion;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: SafeArea(
          child: _gameReady
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20.0),
//                        padding: EdgeInsets.all(40.0),
                        decoration: BoxDecoration(color: Colors.white),
                        child: _question.statement,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _buildAnswerButtons(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: _handleNextPress,
                        child: Icon(
                          FontAwesomeIcons.chevronRight,
                          color: Colors.blueGrey[200],
                        ),
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

//    FirebaseAuth.instance.currentUser().then(
//      (user) {
//        Firestore.instance.collection('users').document(user.uid).updateData(
//            {'globalScore': FieldValue.increment(_quizBrain.gameScore)});
//      },
//    );
    Repository.updateScores(widget._subject, _quizBrain.gameScore);
  }
}
