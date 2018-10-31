
import 'package:flutter/material.dart';

/*void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/': (context) => HomePage(),
      // When we navigate to the "/second" route, build the SecondScreen Widget
      '/second': (context) => ProfilePage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/second'); },
        tooltip: 'Go Forward',
        child: new Icon(Icons.account_circle),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final appTitle = 'test';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: ProfilePageForm(),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {Navigator.pop(context);},
          tooltip: 'Go back',
          child: new Icon(Icons.arrow_back),
        ),
      )
    );
  }
}

class ProfilePageForm extends StatefulWidget {
  @override
  ProfilePageFormState createState() { return ProfilePageFormState(); }
}

class ProfilePageFormState extends State<ProfilePageForm>{
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  String _bioText = "Please enter a bio";

  void _updateBio(String s){
    _bioText = s;
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
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'This is a test',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            }, onFieldSubmitted: (value) {
                _updateBio(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/login.dart';

//void main() => runApp(new MyApp());

void main() {
  runApp(MaterialApp(
    title: 'Login with Routing Demo',
    // Start the app with the "/" named route. In our case, the app will start
    // on the FirstScreen Widget
    initialRoute: '/',
    routes: {
      '/': (context) => LogInPage(),
      // When we navigate to the "/" route, build the FirstScreen Widget
      '/second': (context) => HomePage(),
      // When we navigate to the "/second" route, build the SecondScreen Widget
      '/third': (context) => ProfilePage(),
    },
  ));
}

class LogInPage extends StatefulWidget {
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {

  String _title = 'Please Login';
//  Widget _screen;
  login _login;
  settings _settings;
  bool _authenticated;

  _LoginPageState() {
    _login = new login(onSubmit: (){onSubmit();});
    _settings = new settings();
 //   _screen = _login;
    _authenticated = false;
  }

  void onSubmit() {
    print('Login with: ' + _login.username + ' ' + _login.password);
    //delete the if statement later. just for demo. link with firebase
    if(_login.username == 'user' && _login.password == 'pw') {
      _setAuthenticated(true);
    }
  }

  void _goHome() {
    print('go home');
    setState(() {
      if(_authenticated == true) {
   //     _screen = _settings;
        Navigator.pushNamed(context,'/second');
      }
      else {
    //    _screen = _login;
      }
    }
    );
  }
  void _logout() {
    print('log out');
  }

  void _setAuthenticated(bool auth) {
    setState(() {
      if(auth == true) {
    //    _screen = _settings;
        Navigator.pushNamed(context,'/second');
        _title = 'Welcome';
        _authenticated = true;
      }
      else {
      //  _screen = _login;
        _title = 'Please Login';
        _authenticated = false;
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp (
      title: 'Login Demo',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(_title),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.home),
                onPressed: (){_goHome();}),
            new IconButton(icon: new Icon(Icons.exit_to_app),
                onPressed: (){_logout();}),
          ],
        ),
        body: _login, // _screen,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Launch screen'),
          onPressed: () {
            // Navigate to the second screen using a named route
            Navigator.pushNamed(context, '/third');
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () { Navigator.pushNamed(context, '/third'); },
        tooltip: 'Go to Profile',
        child: new Icon(Icons.account_circle),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final appTitle = 'test';
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
  String _bioText = "Please enter a bio";

  void _updateBio(String s){
    _bioText = s;
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
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'This is a test',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            }, onFieldSubmitted: (value) {
            _updateBio(value);
          },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
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
