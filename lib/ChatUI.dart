import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'GameState.dart';
import 'User.dart';
import 'Message.dart';
import 'Role.dart';

class Chatroom extends StatefulWidget {
  final List<String> _messageHistory = new List();
  final List<String> _mafiaMessageHistory = new List();
  final String name;

  Chatroom(this.name) {}

  @override
  _ChatroomState createState() => _ChatroomState(name);
}

class _ChatroomState extends State<Chatroom> {
  final _controller = TextEditingController();
  Data data;
  User player;
  Message message;
  String name, ip;
  GameState state;
  bool _timerStarted;
  bool _voted;
  bool _tookRoleAction;

  _ChatroomState(this.name) {}

  void initState() {
    super.initState();
    data = Data();
    player = User(name, "127.0.0.1");
    data.addUser(player);
    _timerStarted = false;
    _voted = false;
    _tookRoleAction = false;
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
    String state = data.getState().toString();
    Message received;
    switch(state) {
      case 'PRE_GAME': {
        print("pre");
        received = data.receiveMessage(jsonString, ip);
        addInputToMessageList(received);
      }
      break;

      case 'NIGHT_CHAT':{
        print("mafia chat");
        received = data.receiveMafia(jsonString, ip);
        addInputToMessageList(received);
      }
      break;

      case 'DAY_CHAT': {
        print("chat");
        received = data.receiveMessage(jsonString, ip);
        addInputToMessageList(received);
      }
      break;

      case 'DAY_VOTE':
      case 'NIGHT_VOTE':{
        print("vote");
        data.receiveVote(jsonString, ip);
      }
      break;

      case 'DETECTIVE_CHOOSE':{
        print('detective');
        data.receiveDetective(jsonString, ip);
      }
      break;

      case 'DOCTOR_CHOOSE': {
        print('doctor');
        data.receiveDoctor(jsonString, ip);
      }
      break;
    }
  }

  void addUser(){
    data.addUser(User(name, ip));
    if (data.connectedPlayers.length == 4) {
      setState(() {
        data.startGame(data.connectedPlayers);
        data.updateState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    state = data.getState();
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
        if (data.game.isOver()) {
          setState(() {
            state = GameState.GAME_OVER;
          });
        }
        startTimer(10);
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
        startTimer(10);
        return Scaffold(
          appBar: AppBar(
            title: Text("Vote!"),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: buildVoteIcons(),
          )
        );
      }
      case GameState.NIGHT_CHAT: {
        startTimer(10);
        return Scaffold(
          appBar: AppBar (
            title: Text("Mafia Chat"),
          ),
          body: Container (
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[300],
            child: buildChatComponents(),
          ),
        );
      }
      case GameState.NIGHT_VOTE: {
        startTimer(10);
        return Scaffold(
          appBar: AppBar (
            title: Text("Vote!"),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: buildVoteIcons(),
          ),
        );
      }
      case GameState.DOCTOR_CHOOSE: {
        startTimer(10);
        return Scaffold(
          appBar: AppBar (
            title: Text("Choose who to save!"),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: buildVoteIcons(),
          ),
        );
      }
      case GameState.DETECTIVE_CHOOSE: {
        startTimer(10);
        return Scaffold(
          appBar: AppBar (
            title: Text("Choose who to investigate!"),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: buildVoteIcons(),
          ),
        );
      }
      case GameState.GAME_OVER: {
        return Scaffold(
          appBar: AppBar (
            title: Text("Game Over"),
          ),
          body: Container(
            child: Center (
              child: Text(
                getGameOverText(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }
  }

  void startTimer(int sec) {
    if (_timerStarted) return;
    _timerStarted = true;
    Timer(Duration(seconds: sec), () {
      _timerStarted = false;
      _voted = false;
      _tookRoleAction = false;
      setState(() {
        data.updateState();
      });
    });
  }

  String getGameOverText() {
    if (data.game.scumCount == 0) return "The town has won!";
    else return "The mafia has won!";
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
              decoration: InputDecoration(hintText: 'Enter Name'),
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
    if (state == GameState.DAY_CHAT) {
      return ListView.builder(
        itemCount: widget._messageHistory.length,
          itemBuilder: (BuildContext context, int index) {
            return buildChatMessage(widget._messageHistory[index]);
          }
      );
    }
    else if (state == GameState.NIGHT_CHAT) {
      return ListView.builder(
          itemCount: widget._mafiaMessageHistory.length,
          itemBuilder: (BuildContext context, int index) {
            return buildChatMessage(widget._mafiaMessageHistory[index]);
          }
      );
    }
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
        message = Message(value, player);
        addInputToMessageList(message);
        print("(" + message.sender.name + " " + message.sender.ipAddr + "): " + message.contents);
        data.sendToAll(message);
      },
      decoration: new InputDecoration (
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  void addInputToMessageList(Message message) {
    if (state == GameState.DAY_CHAT) {
      setState(() {
        _controller.clear();
        widget._messageHistory.add(
            message.sender.name + ": " + message.contents);
      });
    }
    else if (state == GameState.NIGHT_CHAT) {
      setState(() {
        _controller.clear();
        widget._mafiaMessageHistory.add(
            message.sender.name + ": " + message.contents);
      });
    }
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

  Widget buildVoteIcons() {
    List<Widget> children = [];
    for (var i = 0; i < data.connectedPlayers.length; i++) {
      String userName = data.connectedPlayers[i];
      Widget voteButton = RaisedButton (
        child: Text(userName),
        onPressed: (() {
          Message m = new Message(userName, player);
          if (state == GameState.DETECTIVE_CHOOSE) {
            if (_tookRoleAction) return;
            _tookRoleAction = true;
            Role r = data.getRole(userName);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Investigation Results"),
                  content: Text(userName+"'s role is "+r.toString()),
                );
              }
            );
          }
          else if (state == GameState.DOCTOR_CHOOSE) {
            if (_tookRoleAction) return;
            _tookRoleAction = true;
            data.sendToAll(m);
          }
          else {
            if (_voted) return;
            if (!data.getUser(userName).isAlive) return;
            _voted = true;
            data.game.killUser(userName);
            data.sendToAll(m);
          }
        }),
      );
      children.add(voteButton);
    }
    return Center(
        child: Column(
          children: children,
        )
    );
  }
}
