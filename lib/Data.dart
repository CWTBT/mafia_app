import 'dart:io';
import 'dart:async';
import 'Dart:convert';

const int ourPort = 6969;

class Data {
  List<Message> messageHistory;
  List<String> connectedPlayers;
  List<String> playerIPs;

  void addUser(User user) {
    if(connectedPlayers.length < 7) {
      connectedPlayers.add(user.name);
      playerIPs.add(user.ipAddr);
      Message temp = Message("Connected", user);
      send(temp, user.ipAddr);
      messageHistory.add(temp);
    } else{
      print("Room has reached capacity");
    }
  }

  void sendToAll(Message message) {
    messageHistory.add(message);
    playerIPs.forEach((ipAddr) {
      send(message, ipAddr);
    });
  }

  void receive(Message message) {
    Message receivedMessage = message;
    messageHistory.add(receivedMessage);
    if(!playerIPs.contains(message.sender.ipAddr)){
      addUser(message.sender);
    }
  }

  Future<SocketOutcome> send(Message messageSent, String ipAddr) async {
    try {
      Socket socket = await Socket.connect(ipAddr, ourPort);
      socket.write(jsonEncode(messageSent));
      socket.close();
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMsg: e.message);
    }
  }

}

class Message {
  final String contents;
  final User sender;
  //final int timeStamp;

  Message.fromJson(Map<String, dynamic> json)
      : contents = json['contents'],
        sender = json['sender'];

  Message(this.contents, this.sender);
}

class User {
  final String name;
  final String ipAddr;

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

