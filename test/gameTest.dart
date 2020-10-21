import 'package:flutter_test/flutter_test.dart';
import 'package:text_messenger/MafiaGame.dart';
import 'package:text_messenger/Data.dart';
import 'package:text_messenger/Role.dart';

void main () {
  List<String> playerNamesList = ["Alice", "Bob", "Carlos", "Diane", "Evan", "Frank", "Gibby"];
  List<User> playerList = [];
  for (int i = 0; i < playerNamesList.length; i++) {
    String ip = "127.0.0." + i.toString();
    playerList.add(new User(playerNamesList[i], ip));
  }
  test('Rolemap is properly initialized', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    expect(game.roleMap, isNotNull);
  });

  test('Each player gets a role', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    expect(game.roleMap.length, equals(game.userList.length));
  });

  test('Highest voted player is selected correctly', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    Map voteMap = {"Alice":0, "Bob":1, "Carlos":3, "Diane":1, "Evan":0, "Frank":0, "Gibby": 2};
    expect(game.countVotes(voteMap), equals(["Carlos"]));
  });

  test('Ties are handled correctly.', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    Map voteMap = {"Alice":0, "Bob":1, "Carlos":2, "Diane":2, "Evan":0, "Frank":1, "Gibby":1};
    expect(game.countVotes(voteMap), equals(["Carlos", "Diane"]));
  });

  test('Highest voted player is successfully killed.', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    Map voteMap = {"Alice":0, "Bob":1, "Carlos":3, "Diane":1, "Evan":0, "Frank":0, "Gibby": 2};
    String mostVotedName = game.countVotes(voteMap)[0];
    game.killUser(mostVotedName);
    User carlos = game.getUser("Carlos");
    expect(carlos.isAlive, equals(false));
  });

  test('Ongoing game is not ended early', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    expect(game.isOver(), equals(false));
  });

  test('Ongoing game is not ended early', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    expect(game.isOver(), equals(false));
  });

  test('Game ends when mafia count == town count', () {
    MafiaGame game = new MafiaGame();
    game.initialize(playerList);
    List<String> townies = [];
    game.roleMap.forEach((k,v) {
      if(v != Role.MAFIA) townies.add(k.name);
    });

    List<bool> gameStates = [];
    for (int i = 0; i < 3; i++) {
      game.killUser(townies[i]);
      gameStates.add(game.isOver());
    }

    expect(gameStates, equals([false, false, true]));
  });
}