import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget{
  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{

  final profilePicURL = '';
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  void _updateBio() async{
    await Firestore.instance.collection('users').document(
        cUser.uid).updateData({'bio': _textController.text});
  }

  @override
  Widget build(BuildContext context){
    updateCurrentUser();
    return new Scaffold(
        key: _formKey,
        body: StreamBuilder(
          stream: Firestore.instance.collection('users').document(cUser.uid).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text('Retrieving data, please be patient!');
            }
            return Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data['profilePic']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      ),
                    ),
                    Text(
                      cUser.displayName,
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                    ),
                    Text(
                        snapshot.data['bio']
                    ),
                    FloatingActionButton(
                      onPressed: (){
                        Navigator.pushNamed(context, '/profileEdit');
                      },
                      tooltip: 'Edit Bio or Picture',
                      child: new Icon(Icons.mode_edit),
                    )
                  ],
                ),
            );
          },
        ), floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
    )
    );
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }
}

class ProfilePageEdit extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final appTitle = 'Profile';
    return  MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: ProfilePageForm(),
      )
    );
  }
}

class ProfilePageForm extends StatefulWidget {
  @override
  ProfilePageFormState createState() { return ProfilePageFormState(); }
}

class ProfilePageFormState extends State<ProfilePageForm> with SingleTickerProviderStateMixin{
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  var profilePic;
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  void _updateBio() async{
    await Firestore.instance.collection('users').document(
        cUser.uid).updateData({'bio': _textController.text});
    Navigator.pushNamed(context, '/home');
  }

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      profilePic = tempImage;
    });
    _updateProfilePic();
  }

  void _updateProfilePic() async{
    final StorageReference picStorageRef = FirebaseStorage.instance.
        ref().
        child('profilepic/${cUser.uid}.jpg');
    picStorageRef.putFile(profilePic);

    FirebaseStorage.instance.
        ref().
        child('profilepic').
        child(cUser.uid);

    Firestore.instance.
      collection('users').
      document(cUser.uid).
      updateData({'profilePic': await picStorageRef.getDownloadURL()});
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return new Form(
      key: _formKey,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Tell us a little about yourself!',
            ),
            controller: _textController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            }, onFieldSubmitted: (value) {},
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  try {
                    _updateBio();
                  }
                  catch (e) {
                    print('Error: $e');
                  }
                }
              },
              child: Text('Submit'),
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                getImage();
              },
              child: Text('Change Image'),
            )
          )
        ],
      ),
    );
  }
}
