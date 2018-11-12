import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  //test func to add a post to our database
  void addToDatabase() async{
    FirebaseUser a = await FirebaseAuth.instance.currentUser();
//    await Firestore.instance.collection('posts').document().setData({ 'title': 'yaboy\'s post', 'author': a.displayName});
//    print('added to database');
    if (a.displayName == 'null') {
      UserUpdateInfo update = UserUpdateInfo();
      update.displayName = 'TestUser';
      a.updateProfile(update);
    }
    String name = a.displayName;
    print('Name = $name ');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Create Post'),
        ),
        body: new Container(
            padding: EdgeInsets.all(16.0),
            child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  new TextField(
                    decoration: new InputDecoration(labelText: 'Write Post'),
                  ),
                  new RaisedButton (
                    child: new Text('Post', style: new TextStyle(fontSize: 20.0)),
                    onPressed: addToDatabase,
                  )
                ]
            )
        )
    );
  }
}