class MafiaGame {
  List<String> playerList;
  Map roleMap = new Map();

  MafiaGame(this.playerList) {
    _initializeRoles();
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