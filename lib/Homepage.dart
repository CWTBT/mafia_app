import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'JoiningScreen.dart';
import 'ChatUI.dart';
import "dart:collection";


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
                child: new TextField(
                  decoration: new InputDecoration(
                      hintText: ("Please input a name")
                  ),
                  onChanged:(String str) {
                    name = str;
                  } ,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.purple, onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new Chatroom()),
                  );
                  },
                  child: Text("Host Game"),
                )
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Colors.purpleAccent, onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new joiningScreen()),
                    );
                  },
                    child: Text("Find Game"),
                  )
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Colors.deepPurpleAccent, onPressed: () {  },
                    child: Text("Quit"),
                  )
              ),
              ]
          ),
    );
  }
}