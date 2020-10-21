import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class joiningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
        body:Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center (
                child: Text("Searching for host..."),
              ),
              Center (
                child: RaisedButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text("Cancel"),
                )
              ),
            ],
          ),
        )
    );
  }

}