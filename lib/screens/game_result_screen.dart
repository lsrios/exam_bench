import 'package:flutter/material.dart';
import 'package:exam_bench/util/quiz_brain.dart';
import 'package:exam_bench/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameResultScreen extends StatefulWidget {
  final QuizBrain quizBrain;

  GameResultScreen(this.quizBrain);

  @override
  _GameResultScreenState createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  List<List<String>> _answersList;
  Iterator<List<String>> _answersIterator;

  Widget get _currentRightAnswer {
    String text = _answersIterator.current.first;
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget get _currentUserAnswer {
    String text = _answersIterator.current.last;
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  bool get _isRight {
    return _answersIterator.current.first == _answersIterator.current.last;
  }

  void _handleNextPress() {
    if (_answersIterator.moveNext()) {
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  BoxConstraints get _answerBoxConstraint {
    double height = (MediaQuery.of(context).size.height / 2) - 10.0;
    double width = MediaQuery.of(context).size.width - 15.0;

    return BoxConstraints(minWidth: width, minHeight: height);
  }

  @override
  void initState() {
    super.initState();
    _answersList = widget.quizBrain.gameAnswers();
    _answersIterator = _answersList.iterator;
    _answersIterator.moveNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Resposta certa vs resposta jogador',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Expanded(
                child: Container(
                    constraints: _answerBoxConstraint,
                    margin: EdgeInsets.all(20.0),
//                        padding: EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
//                child: _question.statement,
                    child: _currentRightAnswer),
              ),
              Expanded(
                child: Container(
                    constraints: _answerBoxConstraint,
                    margin: EdgeInsets.all(20.0),
//                        padding: EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: _isRight ? Colors.white : Colors.redAccent,
                    ),
                    child: _currentUserAnswer),
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
          ),
        ),
      ),
    );
  }
}
