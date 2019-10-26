import 'package:exam_bench/screens/principal_screen.dart';
import 'package:flutter/material.dart';
import 'screens/presentation_screen.dart';
import 'screens/login_screen.dart';
import 'screens/principal_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExamBench',
      initialRoute: PresentationScreen.screenId,
      theme: ThemeData(
        primaryColor: Colors.deepPurple[800],
      ),
      routes: {
        PresentationScreen.screenId: (context) => PresentationScreen(),
        LoginScreen.screenId: (context) => LoginScreen(),
      },
    );
  }
}
