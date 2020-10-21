import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:collection";

List<String> players = ["PLayer 1", "Player 2", "Player 3", "Player 4",
  "PLayer 5", "Player 6, Player 7"];
List<String> voteTally = [];

class VoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Voting..."),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.grey[300],
          child: buildVoteIcons(),
        )
    );
  }


Widget buildVoteIcons() {
    final children = <Widget>[];
    for (var i = 0; i < players.length; i++) {
        children.add(voteButton(players[i]));
    }
  return Center(
      child: Column(
        children: children,
      )
  );
}

RaisedButton voteButton(String playerName){
    Text(playerName);
    onPressed: voteTally.add(playerName);
}

String tallyVotes(List<String> ballot) {
    HashMap<String, int> map = new HashMap<String, int>();
    for (var i = 0; i < voteTally.length; i++) {
      if (map.containsKey(voteTally[i])) {
        map[voteTally[i]] += 1;
      } else {
        map[voteTally[i]] = 1;
      }
    }
    for (var i = 0; i < players.length; i++) {
      String max = "";
      if (map[players[i]] < map[players[i+1]] && players[i+1] != null) {
        max = players[i +1];
    } else {
        max = players[i];
      }
}

}