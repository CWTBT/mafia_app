import 'Data.dart';

class MafiaGame {
  List<User> userList;
  Map roleMap = new Map();

  MafiaGame(this.userList) {
    _initializeRoles();
  }

  // Current solution to tied votes is to return a list of highest voted players
  // and have the calling function check to see if the length > 1.
  List<String> countVotes(Map playersToVotes) {
    int highestVoteCount = 0;
    List<String> mostVotedPlayers = [""];
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

  void killUser(User u) {
    u.isAlive = false;
  }
}

enum Role {
  TOWNIE,
  MAFIA,
  DETECTIVE,
  DOCTOR
}