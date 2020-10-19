class MafiaGame {
  List<String> playerList;
  Map roleMap = new Map();

  MafiaGame(this.playerList) {
    _initializeRoles();
  }

  String countVotes(Map playersToVotes) {
    int highestVoteCount = 0;
    String mostVotedPlayer = "";
    playersToVotes.forEach((k,v) {
      if (v > highestVoteCount) {
        highestVoteCount = v;
        mostVotedPlayer = k;
      }
    });
    return mostVotedPlayer;
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
    for (int i = 0; i < playerList.length; i++) {
      roleMap[playerList[i]] = roleList[i];
    }
  }
}

enum Role {
  TOWNIE,
  MAFIA,
  DETECTIVE,
  DOCTOR
}