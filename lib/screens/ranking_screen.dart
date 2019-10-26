import 'package:flutter/material.dart';
import 'package:exam_bench/constants.dart';
import 'package:exam_bench/widgets/logotype.dart';
import 'package:exam_bench/widgets/leaderboard_table.dart';

//TODO: Implementar o comportamento da tela
class RankingScreen extends StatefulWidget {
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<UserScore> userScoreList = [
    UserScore('1', 100),
    UserScore('2', 100),
    UserScore('3', 100),
    UserScore('4', 100),
    UserScore('5', 100),
    UserScore('6', 100),
    UserScore('7', 100),
    UserScore('8', 100),
    UserScore('9', 100),
    UserScore('10', 100),
    UserScore('Eu', 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Logotype(),
          LeaderboardTable(
            data: userScoreList,
          ),
        ],
      ),
    );
  }
}
