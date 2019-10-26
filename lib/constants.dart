import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final kBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.deepPurple[800],
    Colors.deepPurple[600],
    Colors.deepPurple[300],
  ],
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const rightAnswerIcon = Icon(
  FontAwesomeIcons.checkCircle,
  color: Colors.lightGreenAccent,
);

const wrongAnswerIcon = Icon(
  FontAwesomeIcons.timesCircle,
  color: Colors.redAccent,
);

const blankAnswerIcon = Icon(
  FontAwesomeIcons.square,
  color: Colors.blueGrey,
);

enum GameDifficult {
  easy,
  normal,
  hard,
}
