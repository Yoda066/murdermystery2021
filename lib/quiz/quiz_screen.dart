import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/npc_list/npc_list_item.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  DatabaseReference itemref;
  var loggedUser;
  var List

  <

  Question

  >

  =

  new

  List<Question>();

  @override
  void initState() {
    super.initState();
    itemref = FirebaseDatabase.instance.reference().child("QUIZ");
    itemref.
    itemref.onChildAdded.listen(_onEntryAdded);
    itemref.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/pozadie.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: FirebaseAnimatedList(
                      query: itemref,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return NpcListItem(Npc.fromSnapshot(snapshot));
                      }, // This trailing comma makes auto-formatting nicer for build methods.
                    ),
                  ),
                ))
          ],
        ));
  }
}
