import 'package:flutter/material.dart';
import 'package:nearby/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/location.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

//DateTime epoch = new DateTime(1970, 1, 1);

class CreatePostPage extends StatefulWidget {

  final Record record;
  final PostType postType;

  //constructor with optional parameters(doesnt pass in a record if making a post from the feed)
  CreatePostPage({Key key, this.record, this.postType}) : super (key: key);

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

  void addToDatabase() async{
    FirebaseUser a = await FirebaseAuth.instance.currentUser();
    var epoch = new DateTime.utc(1970, 1, 1);
    if(validatePost(a)) {
      try{
        if (a.displayName == 'null') {
          UserUpdateInfo update = UserUpdateInfo();
          update.displayName = 'LegacyUser';
          a.updateProfile(update);
        }
        var currentLocation = await updateLocation();

//        try {
//          currentLocation = await location.getLocation();
//        } on PlatformException {
//          currentLocation = null;
//        }
//        var doc = Firestore.instance.collection('posts').document();
        if(widget.postType == PostType.post) {

          await Firestore.instance.collection('loc_test_posts').document().setData({
            'name': a.displayName,
            'post': _post,
            'votes': 0,
            'date': DateTime.now().difference(epoch).inSeconds,
            'comments': 0,
            'long' : currentLocation.longitude,
            'lat' : currentLocation.latitude,
//            'lat' : currentLocation['latitude'],
//            'long' : currentLocation['longitude'],
          });
          String name = a.displayName;
          print('added post by $name to database');
          Navigator.pop(context);
        } else {
          await widget.record.reference.collection('comments').document().setData({
            'name': a.displayName,
            'post': _post,
            'votes': 0,
            'date': DateTime.now().difference(epoch).inSeconds,
            'comments': 0,
            'long' : currentLocation.longitude,
            'lat' : currentLocation.latitude,
//            'lat' : currentLocation['latitude'],
//            'long' : currentLocation['longitude'],
          });
          widget.record.reference.updateData({'comments': widget.record.comments + 1});
          Navigator.pop(context);
        }
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

//  void DateTimeTest() {
//    var Date = DateTime.now();
//    print('Date: $Date');
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: widget.postType == PostType.post ? new Text('Create Post') : new Text('Create Comment'),
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
              ),
            ]
          )
        )
      ),
    );
  }
}