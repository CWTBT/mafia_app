import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class joiningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Searching for host..."),
          RaisedButton(
            onPressed: () {Navigator.pop(context);},
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

}