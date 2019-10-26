import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';
import 'package:exam_bench/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QuizBrain {
//  final String gameName;
//  final GameDifficult gameDifficult;
  final String gamePath;
  List<Question> _questionList = [];
//  List<int> _questionTimeList;
  List<int> _userAnswers = [];
  int _gameScore = 0;
  int _currentQuestion = 0;
  final int _gameTimeInSeconds = 180;
  CountdownTimer _gameTimer;

//  QuizBrain({this.gameName, this.gameDifficult});
  QuizBrain({this.gamePath});

  int get gameScore => _gameScore;

  Future<void> simulaBuscaQuestoes() async {
    _questionList = [];
    await Future.delayed(Duration(seconds: 3));
    Iterable<int>.generate(10).forEach((elem) {
      _questionList.add(
        Question(
//          statement: 'Questao n$elem',
          rightAnswer: 2,
          answers: ['a', 'b', 'c', 'd', 'e'],
        ),
      );
    });
  }

  Future<void> loadGame() async {
//    var gameDocument =
//        Firestore.instance.collection('games').document(gameName);
    var documentReference = await Firestore.instance.document(gamePath).get();
    var data = documentReference.data;

    for (var question in data.keys) {
      Image statement = Image.network(data[question]['statement']);
      List<String> answers = (data[question]['answers'] as List).cast<String>();
      _questionList.add(
        Question(
          statement: statement,
          rightAnswer: data[question]['rightAnswer'],
//          answers: question['answers'],
          answers: answers,
        ),
      );
    }

    _gameTimer = CountdownTimer(
      Duration(seconds: _gameTimeInSeconds),
      Duration(seconds: 1),
    );
  }

  Question get firstQuestion {
    _gameTimer = CountdownTimer(
      Duration(seconds: _gameTimeInSeconds),
      Duration(seconds: 1),
    );

    return _questionList.first;
  }

  Question get nextQuestion {
    _gameTimer = CountdownTimer(
      Duration(seconds: _gameTimeInSeconds),
      Duration(seconds: 1),
    );

//    return _questionList[_currentQuestion++];
    return _questionList[_currentQuestion];
  }

  bool get isFinished => _currentQuestion == _questionList.length;

  void checkAnswer(int userAnswerIndex) {
    int points = _gameTimer.remaining.inSeconds;
    _gameTimer.cancel();
    print(_currentQuestion);
    _gameScore += userAnswerIndex == _questionList[_currentQuestion].rightAnswer
        ? points
        : -points;
    _userAnswers.add(userAnswerIndex);
    print(_gameScore);
    ++_currentQuestion;
  }

  List<List<String>> gameAnswers() {
    List<List<String>> answersList = [];

    for (int i = 0; i < _questionList.length; ++i) {
      var question = _questionList[i];
      var rightAnswer = question.answers[question.rightAnswer];
      var userAnswer = question.answers[_userAnswers[i]];
      answersList.add([rightAnswer, userAnswer]);
    }

    return answersList;
  }
}

class Question {
  final Image statement;
  final List<String> answers;
  final int rightAnswer;

  Question({this.statement, this.answers, this.rightAnswer});
}
