import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final List<String> _messageHistory = new List();

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text("Mafia Chatroom"),
      ),
      body: Container (
        color: Colors.grey[300],
        child: Center (
          child: SingleChildScrollView (
            child: Column(
              children: [
                Container (
                  decoration: BoxDecoration (
                    color: Colors.white,
                    border: Border.all (
                      color: Colors.black,
                    ),
                  ),
                  height: 500.0,
                  width: 400.0,
                  margin: const EdgeInsets.all(10.0),
                ),
                Container (
                  decoration: BoxDecoration (
                    color: Colors.white,
                    border: Border.all (
                      color: Colors.black,
                    ),
                  ),
                  child: TextField(
                    decoration: new InputDecoration (
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,

                    ),
                  ),
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
