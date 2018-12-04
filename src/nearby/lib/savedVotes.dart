import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby/record.dart';

class savedVotesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final appTitle = 'Saved Votes';
    return  Scaffold(
          appBar: AppBar(
            title: Text(appTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              )
            ],
          ),

          body: Center(
            child: _buildBody(context),
          ),

        );
  } // Build
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').document('potato').collection('savedPosts').orderBy("date", descending: true).snapshots(), //asks for documents in the 'posts' collections
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(); //if no posts show a moving loading bar that takes up the whole screen

//        return _buildList(context, snapshot.data.documents);
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: snapshot.data.documents.map((data) => _buildListItem(context, data)).toList(),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

    final record = Record.fromSnapshot(data);
    var epoch = DateTime.utc(1970,1,1);
    var postDate = epoch.add(new Duration(seconds: record.date));

    return Padding(
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
              subtitle: Text('Time Posted: ' + postDate.toString()),
            ),
            Container(
              child: Text(record.post),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              alignment: Alignment.topLeft,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildVoteButton(record: record),  // TODO: Disable or integrate voting

                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    Firestore.instance.collection('users').
                    document('testUser'). // TODO change test user to current user
                    collection('savedPosts').
                    document(record.name+record.date.toString()).
                    delete();
                  }, //onPressed
                ),
              ],
            ),
          ]
        )
      )
    );
  }//BuildListItem
} // Saved Votes Page