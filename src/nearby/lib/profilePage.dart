import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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