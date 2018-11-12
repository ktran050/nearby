import 'package:flutter/material.dart';
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
      '/third': (context) => ProfilePage(),
      '/createPost': (context) => CreatePostPage(),//../tePostPage(),
    },
  ));
}
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Feed'),
        ),
        body: _buildList(context, dummySnapshot),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: null,
                onPressed: () { Navigator.pushNamed(context, '/third'); },
                tooltip: 'Go to Profile',
                child: new Icon(Icons.account_circle),
              ),
              FloatingActionButton(
                heroTag:null,
                onPressed: () {Navigator.pushNamed(context,'/settings');},
                tooltip: 'Go to Settings',
                child: new Icon(Icons.settings),
              )
            ]
        )
    );
  }

  Widget _buildList(BuildContext context, List<Map> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Map data) {
    final record = Record.fromMap(data);

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

//Center(
//  //        child: Lorip(),
//    child: new RaisedButton(
//      child: new Text('Add Post to Database', style: new TextStyle(fontSize: 20.0)),
//      //          onPressed: addToDatabase,
//      onPressed: () { Navigator.pushNamed(context, '/createPost');},
//  ),
//),

//class _LoripState extends State<Lorip>{
//  final _feed = <WordPair>[];
//
//  Widget _buildRow(WordPair pair){
//    return ListTile(
//      title: Center(
//          child: Text(pair.asLowerCase)
//      ),
//    );
//  }
//  Widget _buildFeed(){
//    return ListView.builder(
//        itemExtent: 75.0,
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: (context,i){
//          if(i.isOdd) return Divider();
//          final index = i~/2;
//          if(index >= _feed.length){
//            _feed.addAll(generateWordPairs().take(10));
//          }
//          return _buildRow(_feed[index]);
//        }
//    );
//  }
//
//  @override
//  Widget build(BuildContext context){
//    return _buildFeed();
//  }
//}
//
//class Lorip extends StatefulWidget{
//  @override
//  _LoripState createState() => new _LoripState();
//}

