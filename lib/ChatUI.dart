import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:text_messenger/MafiaGame.dart';
import 'Data.dart';
import 'Dart:convert';
import 'GameState.dart';

class Chatroom extends StatefulWidget {
  final List<String> _messageHistory = new List();

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final _controller = TextEditingController();
  Data data;
  User player;
  Message message;
  String name, ip;

  void initState() {
    super.initState();
    data = Data();
    player = User("You", "127.0.0.1");
    data.addUser(player);
    setupServer();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> setupServer() async {
    try {
      ServerSocket server = await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen(listenToSocket); // StreamSubscription<Socket>
    } on SocketException catch (e) {
      print(e.message);
    }
  }

  void listenToSocket(Socket socket) {
    socket.listen((data) {
      setState(() {
        handleIncomingMessage(socket.remoteAddress.address, data);
      });
    });
  }

  void handleIncomingMessage(String ip, Uint8List incomingData) {
    String jsonString = String.fromCharCodes(incomingData);
    Switch(MafiaGame){
      case GameState.DAY_CHAT: {

      }
    }
    Message received = data.receiveMessage(jsonString, ip);
    addInputToMessageList(received.contents);
  }

  void addUser(){
    data.addUser(User(name, ip));
  }

  @override
  Widget build(BuildContext context) {
    GameState state = data.getState();
    switch(state) {
      case GameState.PRE_GAME: {
        return Scaffold(
          appBar: AppBar(
            title: Text("Add Users"),
          ),
          body: Container (
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[300],
            child: buildAddUserFields(),
          ),
        );
      }
      case GameState.DAY_CHAT: {
        return Scaffold (
          appBar: AppBar(
            title: Text("Daytime Chatroom"),
          ),
          body: Container (
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[300],
            child: buildChatComponents(),
          ),
        );
      }
      case GameState.DAY_VOTE: {
        return Scaffold();
      }
      case GameState.NIGHT_CHAT: {
        return Scaffold();
      }
      case GameState.NIGHT_VOTE: {
        return Scaffold();
      }
      case GameState.DOCTOR_CHOOSE: {
        return Scaffold();
      }
      case GameState.DETECTIVE_CHOOSE: {
        return Scaffold();
      }
    }
  }

  Widget buildChatComponents() {
    return Center (
      child: SingleChildScrollView (
        child: Column(
          children: [
            buildChatWindowContainer(),
            SizedBox(height: 10),
            buildInputFieldContainer(),
          ],
        ),
      ),
    );
  }

  Widget buildAddUserFields() {
    return Center (
      child: Column (
        children: [
          TextField(
              onChanged: (text) {
                name = text;
              },
              decoration: InputDecoration(
                  hintText: 'Enter Name')
          ),
          SizedBox(height: 10),
          TextField(
              onChanged: (text) {
                ip = text;
              },
              decoration: InputDecoration(
                  hintText: 'Enter IP')
          ),
          SizedBox(height: 10),
          FloatingActionButton(child: Icon(Icons.add), onPressed: addUser),
        ],
      ),
    );
  }

  Widget buildChatWindowContainer() {
    return Container (
      height: 500.0,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration (
        color: Colors.white,
        border: Border.all (color: Colors.black),
      ),
      child: buildChatWindow(),
    );
  }

  // Examples of ListView.builder came from the following article:
  // https://medium.com/@DakshHub/flutter-displaying-dynamic-contents-using-listview-builder-f2cedb1a19fb
  Widget buildChatWindow() {
    return ListView.builder(
      itemCount: widget._messageHistory.length,
      itemBuilder: (BuildContext context, int index) {
        return buildChatMessage(widget._messageHistory[index]);
      }
    );
  }

  Widget buildInputFieldContainer() {
    return Container (
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      decoration: BoxDecoration (
        color: Colors.white,
        border: Border.all (color: Colors.black,),
      ),
      child: buildInputField(),
    );
  }

  Widget buildInputField() {
    return TextField(
      controller: _controller,
      onSubmitted: (String value) {
        addInputToMessageList(value);
        message = Message(value, player);
        print("(" + message.sender.name + " " + message.sender.ipAddr + "): " + message.contents);
        data.sendToAll(message);
      },
      decoration: new InputDecoration (
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  void addInputToMessageList(String input) {
    setState(() {
      _controller.clear();
      widget._messageHistory.add(input);
    });
  }

  Widget buildChatMessage(String text) {
    return Text (
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 30,
      ),
    );
  }
}
