import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class LogInPage extends StatefulWidget {
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {

  String _title = 'Please Login';
//  Widget _screen;
  login _login;
  //settings _settings;
  bool _authenticated;

  _LoginPageState() {
    _login = new login(onSubmit: (){onSubmit();});
    //_settings = new settings();
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

class login extends StatelessWidget {
  const login ({
    Key key,
    @required this.onSubmit,
  }) : super(key:key);

  final VoidCallback onSubmit;
  static final TextEditingController _user = new TextEditingController();
  static final TextEditingController _pass = new TextEditingController();

  String get username => _user.text;
  String get password => _pass.text;

   @override
  Widget build(BuildContext context) {
    return new Container (
      padding: EdgeInsets.all(12.0),
      child: new Form(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextFormField(controller: _user,
              decoration: new InputDecoration(labelText: 'Enter a username'),
              obscureText: true,),
            new TextFormField(controller: _pass,
              decoration: new InputDecoration(labelText: 'Enter a password'),
              obscureText: true,),
            new RaisedButton(
                child: new Text('Submit', style: new TextStyle(fontSize: 14.0)),
                onPressed: onSubmit,
            )
          ],
        )
      )
    );
  }
}