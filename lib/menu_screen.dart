import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/npc_detail_screen.dart';
import 'package:murdermystery2021/npc_list/npc_list_screen.dart';
import 'package:murdermystery2021/scnene_screen.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class MenuScreen extends StatelessWidget {
  final userChanged;

  MenuScreen({this.userChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.45,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SceneScreen()),
                  );
                },
                child: const Text('Scéna'),
              ),
              RaisedButton(
                onPressed: () {
                  _navigateToVictim(context);
                },
                child: const Text('Obeť'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NpcListScreen()),
                  );
                },
                child: const Text('Zoznam podozrivých'),
              ),
              RaisedButton(
                onPressed: () {
                  _logout();
                },
                child: const Text('Odhlásiť'),
              )
            ]),
      ),
    );
  }

  void _logout() async {
    await MySharedPreferences.logout();
    userChanged(null);
  }

  void _navigateToVictim(BuildContext context) async {
    var itemref = FirebaseDatabase.instance.reference().child("VICTIM");
    await itemref.once().then((DataSnapshot dataSnapshot) async {
      var npc = Npc.fromSnapshot(dataSnapshot);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NpcState(npc)),
      );
    });
  }
}
