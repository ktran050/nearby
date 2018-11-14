//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class ProfilePage extends StatelessWidget{
//  @override
//  Widget build(BuildContext context){
//    final appTitle = 'Profile';
//    return MaterialApp(
//        title: appTitle,
//        home: Scaffold(
//          appBar: AppBar(
//            title: Text(appTitle),
//          ),
//          body: ProfilePageForm(),
//          floatingActionButton: new FloatingActionButton(
//            onPressed: () {Navigator.pop(context);},
//            tooltip: 'Go to home page',
//            child: new Icon(Icons.home),
//          ),
//        )
//    );
//  }
//}
//
//class ProfilePageForm extends StatefulWidget {
//  ProfilePageFormState createState() { return ProfilePageFormState(); }
//}
//
//class ProfilePageFormState extends State<ProfilePageForm>{
//  // Create a global key that will uniquely identify the Form widget and allow
//  // us to validate the form
//  //
//  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
//  final _formKey = GlobalKey<FormState>();
//  String _bioText = "No";
//
//
//  void _updateBio(String btext) async{
//    await Firestore.instance.collection('users').document('UniqueID').setData({ 'bio': btext});
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // Build a Form widget using the _formKey we created above
//    return Form(
//      key: _formKey,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          TextFormField(
//            textAlign: TextAlign.center,
//            decoration: InputDecoration(
//              border: InputBorder.none,
//              hintText: _bioText,
//            ),
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'Please enter some text';
//              }
//            }, onSaved: (value) => _bioText = value,
//          ),
//          Center(
//            child: RaisedButton(
//              onPressed: () {
//                if (_formKey.currentState.validate()) {
//                  _formKey.currentState.save();
//                  _updateBio( _bioText);  // Update call to helper func.
//
//                  Scaffold.of(context).showSnackBar(SnackBar(
//                      content: Text('Processing Data')));
//                }
//              },
//              child: Text('Update'),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby/login.dart';

class ProfilePage extends StatefulWidget{
  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context){
    updateCurrentUser();
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Profile Page'),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').document(cUser.uid).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text('Retrieving data, please be patient!');
            }
            return Column(
              children: <Widget>[
                Text(snapshot.data['bio'])
              ],
            );
          },
        ), floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            onPressed: () { Navigator.pushNamed(context, '/profileEdit'); },
            tooltip: 'Go to Profile',
            child: new Icon(Icons.edit),
          ),
          FloatingActionButton(
            heroTag:null,
            onPressed: () {Navigator.pushNamed(context,'/home');},
            tooltip: 'Go to Settings',
            child: new Icon(Icons.home),
          ),
        ]
    )
    );
  }
}

class ProfilePageForm extends StatefulWidget {
  @override
  ProfilePageFormState createState() { return ProfilePageFormState(); }
}


class ProfilePageEdit extends StatelessWidget{
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
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget> [
              FloatingActionButton(
                onPressed: () {Navigator.pushNamed(context, '/profile');},
                tooltip: 'Go to Profile',
                child: new Icon(Icons.account_circle),
              ),
              FloatingActionButton(
                onPressed: () {Navigator.pushNamed(context, '/home');},
                tooltip: 'Go to home page',
                child: new Icon(Icons.home),
              ),
            ]
        ),
      ),
    );
  }
}

class ProfilePageFormState extends State<ProfilePageForm>{
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  void _updateBio() async{
    await Firestore.instance.collection('users').document(
        cUser.uid).updateData({'bio': _textController.text});
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
              hintText: 'Tell us a litle about yourself!',
            ),
            controller: _textController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            }, onFieldSubmitted: (value) {},
          ),
          Center(
//                padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  _updateBio();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}