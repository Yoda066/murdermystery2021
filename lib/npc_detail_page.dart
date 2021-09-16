import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';

class NpcDetailPage extends StatelessWidget {
  const NpcDetailPage(this.npc);

  final Npc npc;

  final imageWidth = 200.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.only(bottom: 5),
          child: Center(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: npc.image,
                  imageBuilder: (context, imageProvider) => Container(
                    height: imageWidth,
                    width: imageWidth,
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                ),
                SizedBox(height: 10),
                Text(npc.name,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(npc.backstory, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ));
  }
}

class NpcState extends StatefulWidget {
  const NpcState(this.npc);

  final Npc npc;

  @override
  _NpcStateState createState() => _NpcStateState();
}

class _NpcStateState extends State<NpcState> {
  DatabaseReference itemref;
  Npc npc;

  @override
  void initState() {
    super.initState();
    npc = widget.npc;
    itemref = FirebaseDatabase.instance.reference().child("NPCS");
    itemref.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryChanged(Event event) {
    if (widget.npc.key == event.snapshot.key) {
      setState(() {
        npc = Npc.fromSnapshot(event.snapshot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NpcDetailPage(npc);
  }
}
