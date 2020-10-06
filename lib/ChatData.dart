import 'dart:io';
import 'dart:async';

const int ourPort = 4445;

class Chatroom {
  List<Message> _messageHistory;
  List<String> _connectedUserNames;
  List<String> _connectedUserIPs;
  int _currentTimestamp = 0;

  void addUser(User u) {
    _connectedUserNames.add(u.name);
    _connectedUserIPs.add(u.ipAddr);
  }

  void removeUser(User u) {
    _connectedUserNames.remove(u.name);
    _connectedUserIPs.remove(u.ipAddr);
  }

  void sendToAll(Message m) {
    _connectedUserIPs.forEach((ipAddr) {
      send(m, ipAddr);
    });
  }

  Future<SocketOutcome> send(Message m, String ipAddr) async {
    try {
      Socket socket = await Socket.connect(ipAddr, ourPort);
      socket.write(m);
      socket.close();
      _messageHistory.add(m);
      _currentTimestamp += 1;
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMsg: e.message);
    }
  }

  void receive(String messageAsString) {
    Message receivedMessage = _stringToMessage(messageAsString);
    if (receivedMessage.timestamp > _currentTimestamp) {
      _currentTimestamp += 1;
    }
    _messageHistory.add(receivedMessage);
  }

  Message _stringToMessage(String messageAsString) {
    int mTimestamp = parseMessageTimestamp(messageAsString);
    String mSender = parseMessageSender(messageAsString);
    String mContents = parseMessageContents(messageAsString);
    return new Message(mContents, mSender, mTimestamp);
  }

  int parseMessageTimestamp(String m) {
    int timestampEndIndex = m.indexOf("!");
    String timestampString = m.substring(0, timestampEndIndex);
    return int.parse(timestampString);
  }

  String parseMessageSender(String m) {
    int timestampEndIndex = m.indexOf("!");
    int authorEndIndex = m.indexOf(":");
    return m.substring(timestampEndIndex, authorEndIndex);
  }

  String parseMessageContents(String m) {
    int authorEndIndex = m.indexOf(":");
    return m.substring(authorEndIndex);
  }
}

class User {
  final String name;
  final String ipAddr;

  User(this.name, this.ipAddr);
}

class Message {
  final String contents;
  final String sender;
  final int timestamp;

  Message(this.contents, this.sender, this.timestamp);

  String toString() {
    return "$timestamp!$sender: $contents";
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