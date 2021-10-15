import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class NpcDetailScreen extends StatelessWidget {
  const NpcDetailScreen(this.npc, this.user, this.updateAllocation);

  final Npc npc;
  final LoggedUser user;
  final updateAllocation;

  final imageWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: npc.image,
                  imageBuilder: (context, imageProvider) => Container(
                    height: imageWidth,
                    width: imageWidth,
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
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
                Row(
                  children: [
                    Text('Vek: ${npc.age}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Zamestnanie: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Expanded(
                        child: Text('${npc.occupation}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)))
                  ],
                ),
                SizedBox(height: 10),
                Text(npc.backstory, style: TextStyle(fontSize: 15)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _getCallButton(),
                )
              ],
            ),
          )),
    );
  }

  Widget _getCallButton() {
    if (npc.unavailable) {
      return SizedBox(height: 0);
    }

    if (user != null) {
      if (user.type == UserType.PLAYER) {
        return RaisedButton(
            onPressed: _callNpcFunction(),
            child: Text("Privolať", style: TextStyle(fontSize: 15)));
      }

      if (user.type == UserType.NPC && user.key == npc.key) {
        return RaisedButton(
            onPressed: _freeNpcFunction(),
            child: Text("Uvoľniť sa.", style: TextStyle(fontSize: 15)));
      }
    }

    return SizedBox(height: 0);
  }

  Function _callNpcFunction() {
    if (npc.calledBy == null) {
      return () {
        updateAllocation(user);
      };
    } else {
      return null;
    }
  }

  _freeNpcFunction() {
    if (npc.calledBy != null) {
      return () {
        updateAllocation(null);
      };
    } else {
      return null;
    }
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
  LoggedUser user;

  @override
  void initState() {
    super.initState();
    npc = widget.npc;
    itemref = FirebaseDatabase.instance.reference().child("NPCS");
    itemref.onChildChanged.listen(_onEntryChanged);
    _loadUser();
  }

  _onEntryChanged(Event event) {
    if (widget.npc.key == event.snapshot.key) {
      if (mounted) {
        setState(() {
          npc = Npc.fromSnapshot(event.snapshot);
        });
      }
    }
  }

  void _loadUser() async {
    var logged = await MySharedPreferences.getLoggedUser();
    if (mounted) {
      setState(() {
        this.user = logged;
      });
    }
  }

  void _updateAllocation(LoggedUser user) async {
    var key = user == null ? null : user.key;

    try {
      //ak ide hrac niekoho zavolat, zrusi sa zavolanie predchadzajuceho NPC
      if (key != null) {
        await itemref.once().then((DataSnapshot dataSnapshot) async {
          dataSnapshot.value.forEach((key, value) async {
            if (value['calledBy'] == user.key) {
              await itemref.child(key).update({'calledBy': null});
            }
          });
        }).catchError((e) {
          print(e);
        });
      }

      await itemref.child(npc.key).update({'calledBy': key});
      print('Success.');
    } catch (e) {
      print('You got error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NpcDetailScreen(npc, user, _updateAllocation);
  }
}
