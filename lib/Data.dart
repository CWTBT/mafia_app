import 'dart:io';
import 'dart:async';
import 'Dart:convert';
import 'MafiaGame.dart';
import 'Role.dart';
import 'GameState.dart';
import 'User.dart';
import 'Message.dart';

const int ourPort = 8080;

class Data {
  List<Message> messageHistory = [];
  List<Message> mafiaMessageHistory = [];
  List<String> connectedPlayers = [];
  List<String> playerIPs = [];
  Map<String, String> playerRoles = Map<String, String>();
  Map votes = new Map();
  MafiaGame game = new MafiaGame();
  String myIp;

  void addUser(User user) {
    if(connectedPlayers.length < 7) {
      if(!playerIPs.contains(user.ipAddr)) {
        connectedPlayers.add(user.name);
        playerIPs.add(user.ipAddr);
        Message added = Message(user.name + " Connected", user);
        sendToAll(added);
        messageHistory.add(added);
        game.userList.add(user);
      }else{
        print("User is already added");
      }
    } else{
      print("Room has reached capacity");
    }
  }

  void sendToAll(Message message) {
    messageHistory.add(message);
    print(playerIPs);
    playerIPs.forEach((ipAddr) {
      if(ipAddr != message.sender.ipAddr) {
        print("sending to: " + ipAddr);
        send(message, ipAddr);
      }
    });
  }

  Future<SocketOutcome> send(Message messageSent, String ipAddr) async {
    try {
      Map<String,dynamic> msgJson = messageSent.toJson();
      Socket socket = await Socket.connect(ipAddr, ourPort);
      if(playerRoles.isNotEmpty)
        socket.write(jsonEncode(msgJson) + jsonEncode(playerRoles) + jsonEncode(playerIPs) + jsonEncode(connectedPlayers));
      else
        socket.write(jsonEncode(msgJson) + jsonEncode(playerIPs) + jsonEncode(connectedPlayers));
      socket.close();
      return SocketOutcome();
    } on SocketException catch (e) {
      print("didn't send to: " + ipAddr);
      return SocketOutcome(errorMsg: e.message);
    }
  }

  Message receiveMessage(String jsonString, String ip) {
    String msgString = jsonString.substring(jsonString.indexOf("{"), jsonString.lastIndexOf("}") + 1);
    jsonString.replaceFirst(msgString, "");
    Map userMap = jsonDecode(msgString);
    Message temp = Message.fromJson(userMap);
    Message received = Message(temp.contents, User(temp.sender.name, ip));
    if(jsonString.indexOf("{") != -1){
      String roleString = jsonString.substring(jsonString.indexOf("{"), jsonString.lastIndexOf("}") + 1);
      Map<String, String> roleMap = jsonDecode(roleString);
      if(roleMap.isNotEmpty)
        playerRoles = roleMap;
    }
    String listIp = jsonString.substring(jsonString.indexOf("["), jsonString.indexOf("]") + 1);
    jsonString.replaceFirst(listIp, " ");
    String listName = jsonString.substring(jsonString.indexOf("["), jsonString.indexOf("]") + 1);
    List<dynamic> ipList = jsonDecode(listIp);
    List<dynamic> namesList = jsonDecode(listName);
    if(!playerIPs.contains(ip)) {
      myIp = ipList[ipList.length - 1];
      addUser(User(received.sender.name, ip));
    }
    if(playerIPs.length < ipList.length){
      for(int i = 0; i < ipList.length; i++){
        if(!playerIPs.contains(ipList[i]) && ipList[i] != myIp){
          addUser(User(namesList[i], ipList[i]));
        }
      }
    }
    messageHistory.add(received);
    return received;
  }

  void startGame(List<String> nameList) {
    game.initialize();
  }

  void receiveVote(String jsonString, String ip){
    Message message = deserializeMessage(jsonString, ip);
    String target = message.contents;
    votes[target] == null ? votes[target] = 1 : votes[target] += 1;
  }

  Message receiveMafia(String jsonString, String ip){
    Message message = deserializeMessage(jsonString, ip);
    mafiaMessageHistory.add(message);
  }

  void receiveDoctor(String jsonString, String ip){
    Message message = deserializeMessage(jsonString, ip);
    String target = message.contents;
    game.reviveUser(target);
    print(target + " has been saved by the Doctor!");
  }

  void receiveDetective(String jsonString, String ip){
    Message message = deserializeMessage(jsonString, ip);
    String target = message.contents;
    Role r = getRole(target);
    print(target + "'s role is " + r.toString());
  }

  Message deserializeMessage(String jsonString, String ip){
    Map userMap = jsonDecode(jsonString);
    Message temp = Message.fromJson(userMap);
    Message received = Message(temp.contents, User(temp.sender.name, ip));
    return received;
  }

  void resolveVotes() {
    List<String> mostVoted = game.countVotes(votes);
    if(mostVoted.length == 0) game.killUser(mostVoted[0]);
  }

  Role getRole(String userName) {
    User u = getUser(userName);
    return game.roleMap[u];
  }

  User getUser(String userName) {
    return game.namesToPlayers[userName];
  }
  
  GameState getState() {
    return GameState.values[game.stateValue];
  }

  void updateState() {
    if (game.stateValue == 6)  game.stateValue = 1;
    else game.stateValue += 1;
  }
}


class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    _errorMessage = errorMsg;
  }

  bool get sent => _errorMessage.length == 0;
  String get errorMessage => _errorMessage;
}

