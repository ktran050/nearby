import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Create Post'),
        ),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new TextField(
            decoration: new InputDecoration(labelText: 'Write Post')
          )
        )
      );
  }
}
