import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/record.dart';
import 'package:nearby/createPost.dart';

enum Comments{
  none,
  some,
}

class commentPage extends StatefulWidget {
  final Record record;

  //constructor w/ optional parameters
  commentPage({Key key, this.record}) : super (key: key);

  @override
  State<StatefulWidget> createState() => new _commentPageState();
}

class _commentPageState extends State<commentPage> {

  Comments _comments = Comments.none;

  initState(){
    super.initState();
    setState(() {
      _comments = widget.record.comments == 0 ? Comments.none : Comments.some;
    });
  }

  void addComment(){
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
          new CreatePostPage(record: widget.record, postType: PostType.comment),
      )
    );
    if(widget.record.comments > 0){
      print('added comment by ${widget.record.name} to database');
      setState((){
        _comments = Comments.some;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Comments'),
      ),
      body: buildCommentsList(context),
      floatingActionButton: new FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) =>
            new CreatePostPage(record: widget.record, postType: PostType.comment),
          ));
        },
        tooltip: 'Make a Comment',
        child: new Icon(Icons.add_comment),
      ),//floatingActionButton
    );
  }

  Widget buildCommentsList(BuildContext context){
    if(_comments == Comments.none) {
      return new Container (
        alignment: Alignment(0.0,-0.3),
        child: Text('No Comments :/',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        )
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: widget.record.reference.collection('comments').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return LinearProgressIndicator();

          return ListView(
            padding: const EdgeInsets.only(top:20.0),
            children: snapshot.data.documents.map((data) => _buildListItem(context,data)).toList(),
          );
        }
      );
    }
  }

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
              trailing : buildDeleteButton(context, record)
            ),
            Container(
              child: Text(record.post),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              alignment: Alignment.topLeft,
            ),
            ListTile(
              title: buildVoteButton(record: record),
              trailing: IconButton(
                icon: Icon(Icons.add_comment),
                onPressed: () {
//                  Navigator.pushNamed(context, '/commentPage');
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new commentPage(record: record),
                  );
                  Navigator.of(context).push(route);
                }, //onPressed
              ),//IconButton
            ),//ListTile
          ],//Widget
        ),//Column
      ),//Container
    );//Padding
  }//BuildListItem

  Future<bool> getUser(String postName) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.displayName == postName;
  }

  Widget buildDeleteButton(BuildContext context, Record record){
    Future<bool> b = getUser(record.name);
    return new FutureBuilde
        future: b,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {return new Text('');} //prevents compiler error in time between code exec and data retreival from firebase
          if (snapshot.data) {
            return new IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  record.reference.delete();
                  widget.record.reference.updateData({'comments': widget.record.comments - 1});
                }
            );
          } else {
            return new Text('');
          }
        }
    );
  }
}