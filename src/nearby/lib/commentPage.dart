import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/record.dart';

class commentPage extends StatefulWidget {
  final Record record;

  //constructor w/ optional parameters
  commentPage({Key key, this.record}) : super (key: key);

  @override
  State<StatefulWidget> createState() => new _commentPageState();
}

class _commentPageState extends State<commentPage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Comments'),
      ),
      body: new Text('Name: ${widget.record.name}'),
    );
  }
}