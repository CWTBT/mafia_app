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

  Message receiveMessage(String jsonString, String ip) {
    Message message = deserializeMessage(jsonString, ip);
    messageHistory.add(message);
    String listIp = jsonString.substring(jsonString.indexOf("["), jsonString.indexOf("]") + 1);
    jsonString.replaceFirst(listIp, " ");
    String listName = jsonString.substring(jsonString.indexOf("["), jsonString.indexOf("]") + 1);
    List<dynamic> ipList = jsonDecode(listIp);
    List<dynamic> namesList = jsonDecode(listName);
    if(!playerIPs.contains(ip)) {
      myIp = ipList[ipList.length - 1];
      addUser(User(message.sender.name, ip));
    }
    if(playerIPs.length < ipList.length){
      for(int i = 0; i < ipList.length; i++){
        if(!playerIPs.contains(ipList[i]) && ipList[i] != myIp){
          addUser(User(namesList[i], ipList[i]));
        }
      }
    }
    return message;
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
    jsonString = jsonString.substring(0, jsonString.lastIndexOf("}") + 1);
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
    User u = game.getUser(userName);
    return game.roleMap[u];
  }

  Future<SocketOutcome> send(Message messageSent, String ipAddr) async {
    try {
      Map<String,dynamic> msgJson = messageSent.toJson();
      Socket socket = await Socket.connect(ipAddr, ourPort);
      socket.write(jsonEncode(msgJson) + jsonEncode(playerIPs) + jsonEncode(connectedPlayers));
      socket.close();
      return SocketOutcome();
    } on SocketException catch (e) {
      print("didn't send to: " + ipAddr);
      return SocketOutcome(errorMsg: e.message);
    }
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

