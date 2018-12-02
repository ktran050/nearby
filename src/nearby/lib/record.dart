import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby/record.dart';

double sliderValue = 3.0;

enum PostType{
  post,
  comment,
}

class Record {
  final String name;
  final String post;
  final int votes;
  final int comments;
  final DocumentReference reference;
  final double long;
  final double lat;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['comments'] != null),
        assert(map['long'] != null),
        assert(map['lat'] != null),
        assert(map['name'] != null),
        assert(map['post'] != null),
        assert(map['votes'] != null),
        comments = map['comments'],
        long = map['long'],
        lat = map['lat'],
        name = map['name'],
        post = map['post'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$post>";
}

enum Vote{
  notVoted,
  upvoted,
  downvoted,
}

class buildVoteButton extends StatefulWidget {
  final Record record;

  buildVoteButton({Key key, this.record}) : super (key: key);

  @override
  State<StatefulWidget> createState() => new _buildVoteButtonState();
}

class _buildVoteButtonState extends State<buildVoteButton> {

  Vote _vote = Vote.notVoted; //ideally would pull from firestore

  void upVote(){
    if(_vote == Vote.upvoted){
      widget.record.reference.updateData({'votes': widget.record.votes - 1});
      setState((){
        _vote = Vote.notVoted;
      });
    } else {
      if(_vote == Vote.downvoted) {
        widget.record.reference.updateData({'votes': widget.record.votes + 2});
      } else {
        widget.record.reference.updateData({'votes': widget.record.votes + 1});
      }
      setState((){
        _vote = Vote.upvoted;
      });
    }
  }

  void downVote(){
    if(_vote == Vote.downvoted){
      widget.record.reference.updateData({'votes': widget.record.votes + 1});
      setState((){
        _vote = Vote.notVoted;
      });
    } else {
      if(_vote == Vote.upvoted) {
        widget.record.reference.updateData({'votes': widget.record.votes - 2});
      } else {
        widget.record.reference.updateData({'votes': widget.record.votes - 1});
      }
      setState((){
        _vote = Vote.downvoted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget> [
        IconButton(
          icon: Icon(Icons.arrow_drop_up),
          color: ((_vote == Vote.upvoted) ? Colors.orange : Colors.black),
          onPressed: () => upVote(),
        ),
        Text('${widget.record.votes.toString()}'),
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          color: ((_vote == Vote.downvoted) ? Colors.purple[900] : Colors.black),
          onPressed: () => downVote(),
        )
      ],
    );
  }
}


class buildSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _buildSliderState();
}

class _buildSliderState extends State<buildSlider> {

  @override
  Widget build(BuildContext context) {

    String rangeText(double val) {
      switch(val) {
        case 3.0 :
          return '  Global  ';
        case 2.0 :
          return '50 Miles  ';
        case 1.0 :
          return '15 Miles  ';
        case 0.0 :
          return ' 5 Miles  ';
        default:
          return 'Global*  ';
      }
    }
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Slider(
                activeColor: Colors.indigoAccent,
                divisions: 3,
                min: 0.0,
                max: 3.0,
                onChanged: (newRating) {setState((){ sliderValue = newRating;});},
                value: sliderValue,
              )
          ),
          Text(rangeText(sliderValue))
        ],
      ),
    );
  }
}

double getRange(double sliderValue) {
  if(sliderValue == 3.0) {return 100000.0;}
  else if(sliderValue == 2.0) {return 50.0;}
  else if(sliderValue == 1.0) { return 15.0;}
  else { return 5.0;}
}
