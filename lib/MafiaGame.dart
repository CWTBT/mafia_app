import 'Role.dart';
import 'User.dart';

class MafiaGame {
  List<User> userList = new List();
  int scumCount;
  int townCount;
  Map roleMap = new Map();
  Map namesToPlayers = new Map();
  int stateValue;

  MafiaGame() {
    stateValue = 0;
    // These are hardcoded since we only allow one configuration of roles.
    scumCount = 2;
    townCount = 5;
  }

  void _initializeNamesMap() {
    userList.forEach((u) {
      namesToPlayers[u.name] = u;
    });
  }

  void initialize() {
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
    User u = namesToPlayers[uName];
    u.isAlive = false;
    roleMap[u] == Role.MAFIA ? scumCount -= 1 : townCount -= 1;
  }

  void reviveUser(String uName) {
    User u = namesToPlayers[uName];
    u.isAlive = true;
    roleMap[u] == Role.MAFIA ? scumCount += 1 : townCount += 1;
  }

  bool isOver() {
    if (scumCount == townCount) return true;
    else if (scumCount == 0) return true;
    else return false;
  }
}