import 'package:flutter/material.dart';
import 'package:exam_bench/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnswerButton extends StatelessWidget {
  final int answer;
  final Widget child;
  final Function onPress;

  AnswerButton({this.answer, this.child, this.onPress});

  Icon get _icon {
    switch (answer) {
      case 1:
        return wrongAnswerIcon;
      case 2:
        return rightAnswerIcon;
    }
    return blankAnswerIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: RaisedButton(
        color: Colors.white,
        onPressed: onPress,
        child: Row(
          children: <Widget>[
            _icon,
            SizedBox(
              width: 10.0,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
