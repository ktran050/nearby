import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/record.dart';
import 'package:nearby/createPost.dart';

enum Comments{
  none,
  some,
}

class commentPage extends StatefulWidget {
  final Record record;

  //constructor w/ optional parameters
  commentPage({Key key, this.record}) : super (key: key);

  @override
  State<StatefulWidget> createState() => new _commentPageState();
}

class _commentPageState extends State<commentPage> {

  Comments _comments = Comments.none;

  initState(){
    super.initState();
    setState(() {
      _comments = widget.record.comments == 0 ? Comments.none : Comments.some;
    });
  }

  void addComment(){
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
          new CreatePostPage(record: widget.record, postType: PostType.comment),
      )
    );
    if(widget.record.comments > 0){
      print('added comment by ${widget.record.name} to database');
      setState((){
        _comments = Comments.some;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Comments'),
      ),
      body: buildCommentsList(context),
    );
  }

  Widget buildCommentsList(BuildContext context){
    if(_comments == Comments.none) {
      return new Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget> [
            new Container (
  //            alignment: Alignment(0.0,-0.4),
              child: Text('No Comments :/',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              )
            ),
            new Container (
  //            alignment: Alignment(0.0, 0.2),
              child: RaisedButton (
                child: new Text('Add a Comment', style: new TextStyle(fontSize: 20.0)),
                onPressed: addComment,
              )
            ),
          ]
        )
      );
    } else {
      return new Text('There\'s Comments...');
    }
  }
}
