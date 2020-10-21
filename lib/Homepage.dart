import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'JoiningScreen.dart';
import 'package:text_messenger/ChatUI.dart';


String name = "";

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mafia Game")
      ),
      body: layout(context)
      );
  }

  Widget layout(BuildContext context) {
    return Center(
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                color: Colors.grey[300],
                child: new TextField(
                  decoration: new InputDecoration(
                      hintText: ("Please input a name")
                  ),
                  onChanged:(String str) {
                    name = str;
                  } ,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Chatroom(name)),
                  );
                },
                color: Colors.deepPurple,
                child: Text("Host Game"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => joiningScreen())
                  );
                },
                color: Colors.purple,
                child: Text("Join Game"),
              ),
              RaisedButton(
                onPressed:() {},
                color: Colors.purpleAccent,
                child: Text("Quit"),
              ),
            ],
          ),
    );
  }
}