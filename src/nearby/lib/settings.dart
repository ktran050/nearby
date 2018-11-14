import 'package:flutter/material.dart';
import 'dart:async';

class CreateSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreateSettingsPageState();
}

class _CreateSettingsPageState extends State<CreateSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.darkThemeEnabled,
        initialData: false,
        builder: (context,snapshot)=> MaterialApp(
            theme: snapshot.data?ThemeData.dark():ThemeData.light(),
            home: Scaffold(
              appBar: AppBar(
                title: Text("Settings"),
              ),
              body: new Center(
                child: new Column(
                  children: <Widget> [
                    ListTile(
                      title: Text("Dark Theme"),
                      trailing: Switch(
                        value: snapshot.data,
                        onChanged: bloc.changeTheme,
                      ),
                    ),
//                      new RaisedButton (
//                        child: new Text('Themes', style: new TextStyle(fontSize: 20.0)),
//                        onPressed: () {Navigator.pushNamed(context,'/second');},
//                      ),
                    new RaisedButton (
                      child: new Text('Notifications', style: new TextStyle(fontSize: 20.0)),
                      onPressed: () {Navigator.pushNamed(context,'/home');},
                    ),
//                   new RaisedButton (
//                     child: new Text('Location Sharing', style: new TextStyle(fontSize: 20.0)),
//                     onPressed: () {Navigator.pushNamed(context,'/second');},
//                   ),
                  ],
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: () {Navigator.pop(context);},
                tooltip: 'Go to home page',
                child: new Icon(Icons.home),
              ),
            )
        )
    );
  }
}

class Bloc {
  final _themeController = StreamController<bool>.broadcast();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}

final bloc = Bloc();