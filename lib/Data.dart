import 'dart:io';
import 'dart:async';
import 'Dart:convert';
import 'MafiaGame.dart';
import 'Role.dart';
import 'GameState.dart';

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

  Message receiveVote(String jsonString){

  }

  Message deserializeMessage(String jsonString, String ip){
    jsonString = jsonString.substring(0, jsonString.lastIndexOf("}") + 1);
    Map userMap = jsonDecode(jsonString);
    Message temp = Message.fromJson(userMap);
    Message received = Message(temp.contents, User(temp.sender.name, ip));
    return received;
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
}

class Message {
  final String contents;
  final User sender;

  Message.fromJson(Map<String, dynamic> json)
      : contents = json['contents'],
        sender = User.fromJson(json['sender']);

  Map<String, dynamic> toJson() =>
      {
        'contents': contents,
        'sender': sender.toJson(),
      };

  Message(this.contents, this.sender);
}

class User {
  final String name;
  final String ipAddr;
  bool isAlive = true;
  String role;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        ipAddr = json['ipAddr'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'ipAddr': ipAddr,
      };

  String toString() {
    return name;
  }

  User(this.name, this.ipAddr);
}

class SocketOutcome {
  String _errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    _errorMessage = errorMsg;
  }

  bool get sent => _errorMessage.length == 0;
  String get errorMessage => _errorMessage;
}

