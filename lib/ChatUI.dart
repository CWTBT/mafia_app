import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final List<String> _messageHistory = new List();

  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final _controller = TextEditingController();

  void initState() {
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                _buildChatWindow(),
                _buildInputFieldContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatWindow() {
    return Container (
      height: 500.0,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration (
        color: Colors.white,
        border: Border.all (color: Colors.black),
      ),
    );
  }

  Widget _buildInputFieldContainer() {
    return Container (
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      decoration: BoxDecoration (
        color: Colors.white,
        border: Border.all (color: Colors.black,),
      ),
      child: _buildInputField(),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _controller,
      onSubmitted: (String value) {
        _addInputToMessageList(value);
      },
      decoration: new InputDecoration (
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }

  void _addInputToMessageList(String input) {
    setState(() {
      _controller.clear();
      widget._messageHistory.add(input);
      print(widget._messageHistory);
    });
  }
}
