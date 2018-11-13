import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nearby/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatePostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  final postFormKey = new GlobalKey<FormState>();

  String _post;

  bool validatePost(FirebaseUser user){
    final form = postFormKey.currentState;
    if(form.validate()){
      form.save();
      print('Valid Post by ${user.displayName}');
      return true;
    }
    return false;
  }

  //test func to add a post to our database
  void addToDatabase() async{
    FirebaseUser a = await FirebaseAuth.instance.currentUser();
    if(validatePost(a)) {
      try{
        if (a.displayName == 'null') {
          UserUpdateInfo update = UserUpdateInfo();
          update.displayName = 'LegacyUser';
          a.updateProfile(update);
        }
        await Firestore.instance.collection('posts').document().setData({ 'name': a.displayName, 'post': _post});
        print('added post to database');
        String name = a.displayName;
        print('Name = $name ');
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.darkThemeEnabled,
        initialData: false,
        builder: (context,snapshot)=> MaterialApp(
          theme: snapshot.data?ThemeData.dark():ThemeData.light(),
          home: Scaffold(
              appBar: new AppBar(
                title: new Text('Create Post'),
              ),
              body: new Container(
                  padding: EdgeInsets.all(16.0),
                  child: new Form(
                    key: postFormKey,
                    child: new Column(
      //            crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget> [
                        new TextFormField(
                          decoration: new InputDecoration(labelText: 'Write Post'),
                          validator: (input) => input.isEmpty ? '*Can\'t be empty' : null,
                          onSaved: (input) => _post = input,
                        ),
                        new RaisedButton (
                          child: new Text('Post', style: new TextStyle(fontSize: 20.0)),
                          onPressed: addToDatabase,
                        )
                      ]
                    )
                  )
              )
          )
        )
    );
  }
}