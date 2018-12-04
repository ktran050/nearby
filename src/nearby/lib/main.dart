import 'package:flutter/material.dart';
import 'package:nearby/settings.dart';
import 'package:nearby/createPost.dart';
import 'package:nearby/login.dart';
import 'package:nearby/profile.dart';
import 'package:nearby/commentPage.dart';
import 'package:nearby/record.dart';
import 'package:nearby/location.dart';
import 'package:location/location.dart';
import 'package:haversine/haversine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby/notifications.dart';
import 'package:nearby/savedVotes.dart';

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
          '/profileEdit': (context) => ProfilePageEdit(),
          '/savedVotes': (context) => savedVotesPage(),
          '/settings': (context) => CreateSettingsPage(),
        },

        home: DefaultTabController(
          length: 2,
          initialIndex: 0,
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
                  Tab(icon: Icon(Icons.group)),
                  Tab(icon: Icon(Icons.account_circle)),
                ],
              ),
              title: Text('Feed'),
            ),
            body: TabBarView(
              children: [
                _buildBody(context),
//                buildFeed(context),
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
            ),//floatingActionButton
          ),//Scaffold
        ),//TabController
      ),//MaterialApp
    );//StreamBuilder
  }//Widget


//  Widget buildFeed(BuildContext context) {
//    return new Column(
//      children: <Widget> [
//        buildSlider(),
//        Flexible (
//          flex: 1,
//          child: _buildBody(context),
//        ),
//      ],
//    );
//  }

  //asks for a stream of documents from firebase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('loc_test_posts').orderBy("date", descending: true).snapshots(), //asks for documents in the 'posts' collections
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator(); //if no posts show a moving loading bar that takes up the whole screen

//        return _buildList(context, snapshot.data.documents);
        return ListView(
          padding: const EdgeInsets.only(top: 2.0),
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
                color: Colors.black87,
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
    var currentLocation = await updateLocation();

    final h = new Haversine.fromDegrees(
        latitude1: lat,
        longitude1: long,
        latitude2: currentLocation.latitude,
        longitude2: currentLocation.longitude
    );

    double distInMiles = h.distance()*0.000621371;

    return distInMiles;
  }

  Widget buildLocText(BuildContext context, double lat, double long){
    Future<double> dist = getDistance(lat, long);

    return new FutureBuilder(
        future: dist,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {
            return new Text('No Location data');
          } else {
            return new Text('${snapshot.data.toStringAsFixed(2)} miles away');
          }
        }
    );
  }

  //tells flutter how to build each item in the list
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    Future<double> dist = getDistance(record.lat, record.long);
    double range = getRange(sliderValue);

    return new FutureBuilder(
      future: dist,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.data == null) {
          return new Text('No Location data');
        } else if(range < snapshot.data) {
          return new Text('');
        } else {
          return Padding(
            key: ValueKey(record.name),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[300],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    //title: new Text(record.name),  **old title

                    //new stuff
                    title: new GestureDetector(
                      onTap: () {
                        //replace this with with a navigator
                        print('Routes to this persons profile');
                        /*if you need to pass in the record you can do
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                      new UserProfilePage(record: record),
                      //or new ProfilePage(record: record, profileState: otherPerson) if you're fancy
                  ));
                  */
                      },
                      child: new Text(record.name, style: TextStyle(fontWeight: FontWeight.bold),),
                      //end of new stuff

                    ),
                    subtitle: buildLocText(context, record.lat, record.long),
                    trailing : buildDeleteButton(context, record)
//                    trailing: Text(range.toString()),
                  ),
                  Container(
                    child: Text(record.post),
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildVoteButton(record: record),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Firestore.instance.collection('users')
                                .document(
                                'potato'
                              // TODO: have user ID here as type string
                            ).collection('savedPosts')
                                .document(
                                record.name + record.date.toString()
                            )
                                .setData({
                              'name': record.name,
                              'post': record.post,
                              'votes': record.votes,
                              'date': record.date,
                              'comments': record.comments,
                              'long': record.long,
                              'lat': record.lat,
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.add_comment),
                          onPressed: () {
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new commentPage(record: record),
                            );
                            Navigator.of(context).push(route);
                          }, //onPressed
                        ), //IconButton
                      ), //ListTile
                    ], //Widget
                  ), //Column
                ],//Widget
              ),//Column
            ),//Container
          );//Padding
        }
      }
    );

  }//BuildListItem
}//HomePage

