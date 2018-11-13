import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:nearby/profilePage.dart';
//import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final dummySnapshot = [
  {"name": "Donald Trump", "post": "Fake news"},
  {"name": "Ethan Klein", "post": "Fascinating"},
  {"name": "Steph Curry", "post": "What up big fella"},
  {"name": "Brett Kavanaugh", "post": "I like beer"},
  {"name": "Kyle Lowry", "post": "Yay ya hey "},
];

void main() {
  runApp(MaterialApp(
    title: 'Login with Routing Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/second': (context) => HomePage(),
      // When we navigate to the "/second" route, build the SecondScreen Widget
      '/createPost': (context) => CreatePostPage(),//../tePostPage(),
      '/settings': (context) => CreateSettingsPage(),
    },
  ));
}
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.darkThemeEnabled,
        initialData: false,
        builder: (context,snapshot)=> MaterialApp(
      theme: snapshot.data?ThemeData.dark():ThemeData.light(),

      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed:() { Navigator.pop(context);},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed:() { Navigator.pushNamed(context, '/settings');},
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.message)),
                Tab(icon: Icon(Icons.group)),
                Tab(icon: Icon(Icons.account_circle)),
              ],
            ),
            title: Text('Feed'),
          ),
          body: TabBarView(
            children: [
              new Text('Direct Messages here'),
              _buildBody(context),
              _buildProfilePage(context),
            ],
          ),
          floatingActionButton: new FloatingActionButton(
              heroTag: null,
              onPressed: () { Navigator.pushNamed(context, '/createPost'); },
              tooltip: 'Create a Post',
              child: new Icon(Icons.mode_edit),
          ),
        ),
      ),
        )
    );
  }

  Widget _buildProfilePage(BuildContext context){
    return  ProfilePageForm();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
            children: <Widget> [
              ListTile(
                title: Text(record.name),
                subtitle: Text('<Location>'),
                trailing: Text('<Time>'),
              ),
              ListTile(
                title: Text(record.post),
                onTap: () => print(record),
              ),
            ]
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final String post;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['post'] != null),
        name = map['name'],
        post = map['post'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$post>";
}
