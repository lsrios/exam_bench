import 'package:exam_bench/screens/login_screen.dart';
import 'package:exam_bench/screens/play_screen.dart';
import 'package:exam_bench/screens/ranking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'summary_screen.dart';

class PrincipalScreen extends StatefulWidget {
  static String get screenId => 'principalScreenId';

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

// TODO: Verificar o CircularAvatar
class _PrincipalScreenState extends State<PrincipalScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screensList = [
    SummaryScreen(),
    PlayScreen(),
    RankingScreen(),
  ];

  void _handleItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.screenId);
            },
          ),
        ],
      ),
      body: _screensList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handleItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text('Summary'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.gamepad),
            title: Text('Play'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.award),
            title: Text('Ranking'),
          ),
        ],
      ),
    );
  }
}
