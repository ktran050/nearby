import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:nearby/profile.dart';
import 'package:nearby/commentPage.dart';
import 'package:nearby/record.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby/notifications.dart';

void main() {
  runApp(MaterialApp(
    title: 'Nearby App',
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/home': (context) => HomePage(),
      '/createPost': (context) => CreatePostPage(),
      '/settings': (context) => CreateSettingsPage(),
      '/commentPage': (context) => commentPage(),
      '/profileEdit': (context) => ProfilePageEdit(),
      '/notifications': (context) => CreateNotificationsPage(),
    },
  ));
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context,snapshot)=> MaterialApp(
        theme: snapshot.data?ThemeData.dark():ThemeData.light(),
        routes: {
          '/commentPage': (context) => commentPage(),
//          '/profileEdit': (context) => ProfilePageEdit(),
        },

        home: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                )
              ],
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.message)),
                  Tab(icon: Icon(Icons.group)),
                  Tab(icon: Icon(Icons.account_circle)),
                ],
              ),
              title: Text('Feed'),
            ),
            body: TabBarView(
              children: [
                new Text('Direct Messages here'),
                _buildBody(context),
                ProfilePage(),
              ],
            ),
            floatingActionButton: new FloatingActionButton(
              heroTag: null,
              onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new CreatePostPage(postType: PostType.post),
                ));
              },
              tooltip: 'Create a Post',
              child: new Icon(Icons.mode_edit),
            ), //floatingActionButton
          ),//Scaffold
        ),//TabController
      ),//MaterialApp
    );//StreamBuilder
  }//Widget

  //asks for a stream of documents from firebase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('loc_test_posts').orderBy("date", descending: true).snapshots(), //asks for documents in the 'posts' collections
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


  //This func and the next widget build implement the delete button
  Future<bool> getUser(String postName) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.displayName == postName;
  }

  Widget buildDeleteButton(BuildContext context, Record record){
    Future<bool> b = getUser(record.name);
    return new FutureBuilder(
        future: b,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {return new Text('');} //prevents compiler error in time between code exec and data retreival from firebase
          if (snapshot.data) {
            return new IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  record.reference.delete();
                }
            );
          } else {
            return new Text('');
          }
        }
    );
  }

  //this func and the next widget is supposed to calc the distance in a post to the current user,
  Future<double> getDistance(double lat, double long) async {
    var currentLocation = <String, double>{};
    var location = new Location();
    double PI = 3.14159;

//    try {
      currentLocation = await location.getLocation();
//    } on PlatformException {
//      currentLocation = null;
//    }

    final harvesine = new Haversine.fromDegrees(
        latitude1: lat,
        longitude1: long,
        latitude2: currentLocation['latitude'],
        longitude2: currentLocation['longitude']
    );

    print('distance: ${harvesine.distance()}');

    return harvesine.distance();
  }

  Widget buildLocText(BuildContext context, double lat, double long){
    Future<double> dist = getDistance(lat, long);

    return new FutureBuilder(
        future: dist,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {return new Text('No data');} //this is always null for some reason
          if (snapshot.data) {
            return new Text('${snapshot.data} miles away');
          } else {
            return new Text('No Location');
          }
        }
    );
  }



  //tells flutter how to build each item in the list
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
              subtitle: Text('Lat: ${record.lat} Long: ${record.long}'),
//              subtitle: buildLocText(context, record.lat, record.long),  //trying to get it to print distance from user
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
}//HomePage

