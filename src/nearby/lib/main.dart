import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      '/settings': (context) => CreateSettingsPage(),
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
      body: Center(
//        child: Lorip(),
        child: new RaisedButton(
          child: new Text('Add Post to Database', style: new TextStyle(fontSize: 20.0)),
//          onPressed: addToDatabase,
            onPressed: () { Navigator.pushNamed(context, '/createPost');},
        ),
      ),
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

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final appTitle = 'Profile';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
          ),
          body: ProfilePageForm(),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {Navigator.pop(context);},
            tooltip: 'Go to home page',
            child: new Icon(Icons.home),
          ),
        )
    );
  }
}

class ProfilePageForm extends StatefulWidget {
  ProfilePageFormState createState() { return ProfilePageFormState(); }
}

class ProfilePageFormState extends State<ProfilePageForm>{
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  String _bioText = "No";


  void _updateBio(String btext) async{
    await Firestore.instance.collection('users').document('UniqueID').setData({ 'bio': btext});
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: _bioText,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            }, onSaved: (value) => _bioText = value,
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _updateBio( _bioText);  // Update call to helper func.

                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Processing Data')));
                }
              },
              child: Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}