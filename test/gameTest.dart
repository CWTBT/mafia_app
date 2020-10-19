import 'package:flutter_test/flutter_test.dart';
import 'package:text_messenger/MafiaGame.dart';

void main () {
  test('Rolemap is properly initialized', () {
    MafiaGame game = new MafiaGame(["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"]);
    expect(game.roleMap, isNotNull);
  });

  test('Each player gets a role', () {
    MafiaGame game = new MafiaGame(["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"]);
    print(game.roleMap);
    expect(game.roleMap.length, equals(game.playerList.length));
  });
}