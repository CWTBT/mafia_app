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
        backgroundColor: Colors.black,
        title: Text("Mafia Game"),
      ),
      body: layout(context)
      );
  }

  Widget layout(BuildContext context) {
    return Center(
         child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/MafiaLogo.png'),
              height: 280, width: 280),
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
                  color: Colors.deepPurpleAccent, onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new Chatroom(name)),
                  );
                  },
                  child: Text("Host Game"),
                )
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Colors.deepPurpleAccent, onPressed: () { Navigator.push(
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