import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final List<String> _messageHistory = new List();

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: Text("Chatroom"),
      ),
    );
  }
}
