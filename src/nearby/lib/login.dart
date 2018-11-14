import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/foundation.dart';

var mAuth = FirebaseAuth.instance;
FirebaseUser cUser = null;

void updateCurrentUser() async{
  cUser = await mAuth.currentUser();
}

class LoginPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => new _LoginPageState();
}

//implements 2 different states for the page.
// i.e. on button press, switches two buttons implemented below
enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  //lets us save the username and password
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _displayName;
  FormType _formType = FormType.login;

  //checks validators in the widget below I.E. if the email and password is empty or not
  //saves input into _email and _password
  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print('Valid Form. Email: $_email, password: $_password'); //debug test to show the un/pw persists
      return true;
    }
    return false;
  }

  //checks firebase with the email and password
  void validateAndSubmit() async {
    if(validateAndSave()){
      try {
        if(_formType == FormType.login) {
          print('waiting for firebase'); //debug test
          FirebaseUser user = await mAuth.signInWithEmailAndPassword(email: _email, password: _password);
          Navigator.pushNamed(context, '/home'); //if the user logs in with right credentials they're taken to the home screen
          updateCurrentUser();
          print('Signed In: ${user.uid}');
        } else {
          print('waiting for firebase');
          FirebaseUser user = await mAuth.createUserWithEmailAndPassword(email: _email, password: _password);
          UserUpdateInfo update = UserUpdateInfo();
          update.displayName = _displayName;
          user.updateProfile(update);
          Firestore.instance.collection('users').document(user.uid).setData({'bio': ''});
          updateCurrentUser();
          Navigator.pushNamed(context, '/home');
          print('Registered user: ${user.uid}');
        }
      }
      catch (e) {
        print('Error: $e'); //prints out debug msg if the email/password is invalid or in the wrong format
      }
    }
  }

  //switches the state
  void moveToRegister(){
    formKey.currentState.reset(); //clears User input when they tap 'Don't Have An Account'
    setState((){
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.login;
    });
  }

  @override
    Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         title: new Text('Welcome'),
       ),
       body: new Container(
         padding: EdgeInsets.all(16.0),
         child: new Form(
           key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildTextFields() + buildLoginButtons(),
          )
         )
       )
     );
  }

  List<Widget> buildTextFields(){
    if(_formType == FormType.login) {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Enter Email'),
          validator: (input) => input.isEmpty ? '*required' : null,
          onSaved: (input) => _email = input,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Enter Password'),
          validator: (input) => input.isEmpty ? '*required' : null,
          onSaved: (input) => _password = input,
          obscureText: true,
        ),
      ];
    } else {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Enter Display Name'),
          validator: (input) => input.isEmpty ? '*required' : null,
          onSaved: (input) => _displayName = input,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Enter Email'),
          validator: (input) => input.isEmpty ? '*required' : null,
          onSaved: (input) => _email = input,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Enter Password'),
          validator: (input) => input.isEmpty ? '*required' : null,
          onSaved: (input) => _password = input,
          obscureText: true,
        ),
      ];
    }
  }

  //changes what the buttons say depending on the state
  List<Widget> buildLoginButtons() {
    if(_formType == FormType.login){
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
            child: new Text('Don\'t Have an Account?', style: new TextStyle(fontSize: 20.0)),
            onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text('Sign Up', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
            child: new Text('Already Have an Account?', style: new TextStyle(fontSize: 20.0)),
            onPressed: moveToLogin,
        ),
      ];
    }
  }
}
