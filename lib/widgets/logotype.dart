import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Logotype extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.gamepad,
          color: Colors.yellow[500],
          size: 50.0,
        ),
        Text(
          'ExamBench',
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.indigo[800],
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
