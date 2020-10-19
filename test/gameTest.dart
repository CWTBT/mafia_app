import 'package:flutter_test/flutter_test.dart';
import 'package:text_messenger/MafiaGame.dart';

void main () {
  test('Rolemap is properly initialized', () {
    MafiaGame game = new MafiaGame(["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"]);
    expect(game.roleMap, isNotNull);
  });

  test('Each player gets a role', () {
    MafiaGame game = new MafiaGame(["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"]);
    expect(game.roleMap.length, equals(game.playerList.length));
  });

  test('Each player gets a role', () {
    MafiaGame game = new MafiaGame(["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"]);
    Map voteMap = {"Alice":0, "Bob":1, "Carlos":3, "Diane":1, "Evan":0, "Frank":0, "Gibby": 2};
    expect(game.countVotes(voteMap), equals("Carlos"));
  });
}