import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/npc_list/npc_list_item.dart';

class NpcListScreen extends StatefulWidget {
  @override
  _NpcListState createState() => _NpcListState();
}

class _NpcListState extends State<NpcListScreen> {
  DatabaseReference itemref;
  var locations = List();
  var loggedUser;

  @override
  void initState() {
    super.initState();
    itemref = FirebaseDatabase.instance.reference().child("NPCS");
    itemref.onChildAdded.listen(_onEntryAdded);
    itemref.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryChanged(Event event) {
    var old = locations.singleWhere((element) {
      return element.key == event.snapshot.key;
    });

    if (mounted) {
      setState(() {
        locations[locations.indexOf(old)] = Npc.fromSnapshot(event.snapshot);
      });
    }
  }

  _onEntryAdded(Event event) {
    if (mounted) {
      setState(() {
        locations.add(Npc.fromSnapshot(event.snapshot));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: itemref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return NpcListItem(Npc.fromSnapshot(snapshot));
                }, // This trailing comma makes auto-formatting nicer for build methods.
              ),
            )
          ],
        ));
  }
}
