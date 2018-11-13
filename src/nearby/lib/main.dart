import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:nearby/profilePage.dart';
//import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//
final dummySnapshot = [
  {"name": "Filip", "post": "hi", "votes": 15},
  {"name": "Abraham", "post": "bruh", "votes": 14},
  {"name": "Richard", "post": "hey", "votes": 11},
  {"name": "Ike", "post": "sup", "votes": 10},
  {"name": "Justin", "post": "yo", "votes": 1},
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
    return MaterialApp(

      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
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
            onPressed: () {
              Navigator.pushNamed(context, '/createPost');
            },
            tooltip: 'Create a Post',
            child: new Icon(Icons.mode_edit),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return ProfilePageForm();
  }

  //asks for a stream of documents from firebase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(); //if no posts show a loading bar

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

  //tells flutter how to build each item in the list
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //DocumentSnapshot
    final record = Record.fromSnapshot(data); //fromSnapshot

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
            children: <Widget>[
              ListTile(
                title: Text(record.name),
                subtitle: Text('<Location>'),
                trailing: Text('<Time>'),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(record.post),
                    ),
                    Text('${record.votes.toString()} '),
//                    buildIconButton(),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: Colors.black, //(_voted ? Colors.blue : Colors.black),
                      onPressed: () => record.reference.updateData({'votes': record.votes + 1}),
                    )
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

//class buildIconButton extends StatefulWidget {
//  @override
//  _buildIconButtonState createState() => _buildIconButtonState();
//}
//
//class _buildIconButtonState extends State<buildIconButton> {
//
//  bool _voted = false;
//
//  void _toggleVote() {
//    setState(() {
//      if (_voted) {
//        record.reference.updateData({'votes': record.votes - 1});
//        _voted = false;
//      } else {
//        record.reference.updateData({'votes': record.votes + 1});
//        _voted = true;
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return IconButton(
//      icon: Icon(Icons.thumb_up),
//      color: (_voted ? Colors.blue : Colors.black),
//      onPressed: _toggleVote,
//    );
//  }
//}

class Record {
  final String name;
  final String post;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['post'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        post = map['post'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$post>";
}
