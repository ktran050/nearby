import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:nearby/profile.dart';
import 'package:nearby/commentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    title: 'Login with Routing Demo',
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/createPost': (context) => CreatePostPage(),
      '/settings': (context) => CreateSettingsPage(),
      '/commentPage': (context) => commentPage(),
      '/profileEdit': (context) => ProfilePageForm(),
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
        routes: {
          '/commentPage': (context) => commentPage(),
        },
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
            ),//floatingActionButton
          ),//Scaffold
        ),//TabController
      ),//MaterialApp
    );//StreamBuilder
  }//Widget

  Widget _buildProfilePage(BuildContext context) {
    return ProfilePage();
  }

//everything below here right now builds the feed

  //asks for a stream of documents from firebase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('posts').snapshots(), //asks for documents in the 'posts' collections
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(); //if no posts show a moving loading bar that takes up the whole screen

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
          children: <Widget>[
            ListTile(
              title: Text(record.name),
              subtitle: Text('<Location>,<Time>'),
              trailing: IconButton(
                icon: Icon(Icons.add_comment),
                onPressed: () {
                  Navigator.pushNamed(context, '/commentPage');
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(record.post),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    color: Colors.black,
                    onPressed: () => record.reference.updateData({'votes': record.votes + 1}),
                  ),
                  Text('${record.votes.toString()}'),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    color: Colors.black, //(_voted ? Colors.blue : Colors.black),
                    onPressed: () => record.reference.updateData({'votes': record.votes - 1}),
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

