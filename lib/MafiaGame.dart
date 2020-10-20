import 'Data.dart';
import 'GameState.dart';
import 'Role.dart';

class MafiaGame {
  List<User> userList;
  int scumCount;
  int townCount;
  Map roleMap = new Map();
  Map _namesToPlayers = new Map();
  int _stateValue;

  MafiaGame(this.userList) {
    _initializeRoles();
    _initializeNamesMap();
    _stateValue = 0;

    // These are hardcoded since we only allow one configuration of roles.
    scumCount = 2;
    townCount = 5;
  }

  void _initializeNamesMap() {
    userList.forEach((u) {
      _namesToPlayers[u.name] = u;
    });
  }

  // Current solution to tied votes is to return a list of highest voted players
  // and have the calling function check to see if the length > 1.
  List<String> countVotes(Map playersToVotes) {
    int highestVoteCount = 0;
    List<String> mostVotedPlayers = [];
    playersToVotes.forEach((k,v) {
      if (v > highestVoteCount) {
        highestVoteCount = v;
        mostVotedPlayers = [k];
      }
      else if (v == highestVoteCount) {
        mostVotedPlayers.add(k);
      }
    });
    return mostVotedPlayers;
  }

  void _initializeRoles() {
    List<Role> roleList = [
      Role.TOWNIE,
      Role.TOWNIE,
      Role.TOWNIE,
      Role.MAFIA,
      Role.MAFIA,
      Role.DETECTIVE,
      Role.DOCTOR
    ];

    roleList.shuffle();
    for (int i = 0; i < userList.length; i++) {
      roleMap[userList[i]] = roleList[i];
    }
  }

  void killUser(String uName) {
    User u = getUser(uName);
    u.isAlive = false;
    roleMap[u] == Role.MAFIA ? scumCount -= 1 : townCount -= 1;
  }

  void reviveUser(String uName) {
    User u = getUser(uName);
    u.isAlive = true;
    roleMap[u] == Role.MAFIA ? scumCount += 1 : townCount += 1;
  }

  User getUser(String userName) {
    return _namesToPlayers[userName];
  }

  void progressGameState() {
    if (_stateValue == 5)  _stateValue = 0;
    else _stateValue += 1;
  }

  bool isOver() {
    return scumCount == townCount ? true : false;
  }

  GameState getState() {
    return GameState.values[_stateValue];
  }
}