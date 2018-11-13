import 'package:flutter/material.dart';

class CreateSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreateSettingsPageState();
}

class _CreateSettingsPageState extends State<CreateSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new Center(
          child: new Column(
              children: <Widget> [
                new RaisedButton (
                  child: new Text('Themes', style: new TextStyle(fontSize: 20.0)),
                  onPressed: () {Navigator.pushNamed(context,'/second');},
                ),
                new RaisedButton (
                  child: new Text('Notifications', style: new TextStyle(fontSize: 20.0)),
                  onPressed: () {Navigator.pushNamed(context,'/second');},
                ),
//                   new RaisedButton (
//                     child: new Text('Location Sharing', style: new TextStyle(fontSize: 20.0)),
//                     onPressed: () {Navigator.pushNamed(context,'/second');},
//                   ),
              ]
          )
      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: () {Navigator.pop(context);},
//        tooltip: 'Go to home page',
//        child: new Icon(Icons.home),
//      ),
    );
  }
}
