import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class commentPage extends StatefulWidget {
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
      body: new Text('Comments here'),
    );
  }
}