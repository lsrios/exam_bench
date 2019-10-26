import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// TODO: parametrizar os dados
class LeaderboardTable extends StatelessWidget {
  final List<UserScore> data;

  LeaderboardTable({this.data});

  TableRow get _tableHeader => TableRow(children: [
        TableCell(
          child: Text('Rank'),
        ),
        TableCell(
          child: Text('Player'),
        ),
        TableCell(
          child: Text('Points'),
        ),
      ]);

  List<TableRow> _buildRows() {
    List<TableRow> rowsList = [_tableHeader];
    var textStyle = TextStyle(fontSize: 15.0);

    for (int i = 0; i < data.length; ++i) {
      rowsList.add(TableRow(
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(5.0),
//          color: Colors.deepPurple[400],
//        ),
        children: [
          TableCell(
              child: Text(
            '#$i',
            style: textStyle,
          )),
          TableCell(
              child: Text(
            data[i].username,
            style: textStyle,
          )),
          TableCell(
              child: Text(
            data[i].score.toString(),
            style: textStyle,
          )),
        ],
      ));
    }
    return rowsList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      decoration: BoxDecoration(
//        color: Colors.white,
        color: Colors.deepPurple[400],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.deepPurple[600],
          width: 2.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.award),
                Text(
                  'Ranking Enem',
                  style: TextStyle(fontSize: 25.0),
                ),
              ],
            ),
          ),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(width: 1.0, color: Colors.deepPurple[600]),
            ),
            columnWidths: {0: FractionColumnWidth(0.2)},
            children: _buildRows(),
          ),
        ],
      ),
    );
  }
}

class UserScore {
  final String username;
  final int score;

  UserScore(this.username, this.score);
}
