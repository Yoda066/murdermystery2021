import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/models/QuizState.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class NpcDetailScreen extends StatelessWidget {
  const NpcDetailScreen(
      this.npc, this.user, this.updateAllocation, this.quizState);

  final Npc npc;
  final LoggedUser user;
  final updateAllocation;
  final QuizState quizState;

  final imageWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(user?.name ?? "")),
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Expanded(child: getScrollView()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _getCallButton(),
                )
              ],
            )));
  }

  Widget getScrollView() {
    return SingleChildScrollView(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                    image: AssetImage('images/profiles/${npc.image}'),
                    height: imageWidth,
                    width: imageWidth),
              ),
              SizedBox(height: 10),
              Text(npc.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text('Vek: ${npc.age}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zamestnanie: ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Expanded(
                      child: Text('${npc.occupation}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)))
                ],
              ),
              SizedBox(height: 10),
              Text(
                npc.backstory,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCallButton() {
    if (npc.unavailable || this.quizState == QuizState.DONE) {
      return SizedBox(height: 0);
    }

    if (user != null) {
      if (user.type == UserType.PLAYER) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
              onPressed: _callNpcFunction(), child: Text("Privolať")),
        );
      }

      if (user.type == UserType.NPC && user.key == npc.key) {
        return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
                onPressed: _freeNpcFunction(), child: Text("Uvoľniť sa.")));
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
  QuizState quizState;

  @override
  void initState() {
    super.initState();
    npc = widget.npc;
    itemref = FirebaseDatabase.instance.reference().child("NPCS");
    itemref.onChildChanged.listen(_onEntryChanged);
    _loadUserAndState();
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

  void _loadUserAndState() async {
    var logged = await MySharedPreferences.getLoggedUser();
    var state = await MySharedPreferences.getQuizState();
    if (mounted) {
      setState(() {
        user = logged;
        quizState = state;
      });
    }
  }

  void _updateAllocation(LoggedUser user) async {
    var key = user?.key;

    try {
      //ak ide hrac niekoho zavolat, zrusi sa zavolanie predchadzajuceho NPC
      if (key != null) {
        await itemref.once().then((DataSnapshot dataSnapshot) async {
          var alreadyCalledSomeone = false;
          dataSnapshot.value.forEach((key, value) async {
            if (value['calledBy'] == user.name) {
              alreadyCalledSomeone = true;
            }
          });

          if (alreadyCalledSomeone) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Nemôžete privolať iného podozrivého, kým neskončí prvý výsluch.")));
          } else {
            await itemref.child(npc.key).update({'calledBy': user.name});
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${npc.name} bude ochvíľu pri vás.")));
          }
        }).catchError((e) {
          print(e);
        });
      } else {
        await itemref.child(npc.key).update({'calledBy': null});
      }
    } catch (e) {
      print('You got error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NpcDetailScreen(npc, user, _updateAllocation, quizState);
  }
}
