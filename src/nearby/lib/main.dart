import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/login.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/profile.dart';
//import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    title: 'Login with Routing Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      // When we navigate to the "/" route, build the Login Page
      '/home': (context) => HomePage(),
      '/profile': (context) => ProfilePage(),
      '/profileEdit': (context) => ProfilePageEdit(),
      '/settings': (context) => settings(),
    },
  ));
}

class _LoripState extends State<Lorip>{
  final _feed = <WordPair>[];

  Widget _buildRow(WordPair pair){
    return ListTile(
      title: Center(
          child: Text(pair.asLowerCase)
      ),
    );
  }
  Widget _buildFeed(){
    return ListView.builder(
      itemExtent: 75.0,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context,i){
        if(i.isOdd) return Divider();
        final index = i~/2;
        if(index >= _feed.length){
          _feed.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_feed[index]);
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return _buildFeed();
  }
}

class Lorip extends StatefulWidget{
  @override
  _LoripState createState() => new _LoripState();
}

class HomePage extends StatelessWidget {

  //test func to add a post to our database
  void addToDatabase() async{
    FirebaseUser a = await FirebaseAuth.instance.currentUser(); //Added line
    await Firestore.instance.collection('posts').document().setData({ 'title': 'yaboy\'s post', 'author': cUser.uid});

    print('added to database');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Center(
//        child: Lorip(),
        child: new RaisedButton(
          child: new Text('Add Post to Database', style: new TextStyle(fontSize: 20.0)),
          onPressed: addToDatabase,
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            onPressed: () { Navigator.pushNamed(context, '/profile'); },
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
}

