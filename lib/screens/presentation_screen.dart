import 'package:exam_bench/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:exam_bench/widgets/logotype.dart';

class PresentationScreen extends StatefulWidget {
  static String get screenId => 'presentationScreen';

  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 1),
      () {
        Navigator.popAndPushNamed(context, LoginScreen.screenId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Logotype(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Make studing a game!',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.yellow[400],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
