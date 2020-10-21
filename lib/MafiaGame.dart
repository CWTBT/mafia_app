import 'Data.dart';
import 'GameState.dart';
import 'Role.dart';
import 'User.dart';
import 'Message.dart';

class MafiaGame {
  List<User> userList;
  int scumCount;
  int townCount;
  Map roleMap = new Map();
  Map _namesToPlayers = new Map();
  int stateValue;

  MafiaGame() {
    stateValue = 0;
    // These are hardcoded since we only allow one configuration of roles.
    scumCount = 2;
    townCount = 5;
  }

  void _initializeNamesMap() {
    userList.forEach((u) {
      _namesToPlayers[u.name] = u;
    });
  }

  void initialize(List<User> uList) {
    userList = uList;
    _initializeRoles();
    _initializeNamesMap();
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
    _initializeNamesMap();
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

  bool isOver() {
    return scumCount == townCount ? true : false;
  }
}