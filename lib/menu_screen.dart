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
        widthFactor: 0.6,
        heightFactor: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            getMainMenu(context),
            Expanded(child: SizedBox(), flex: 2),
            ElevatedButton(
              onPressed: () {
                _logout();
              },
              child: const Text('VYRIEŠIŤ'),
            ),
            Expanded(child: SizedBox(), flex: 1),
          ],
        ),
      ),
    );
  }

  Widget getMainMenu(BuildContext context) {
    return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SceneScreen()),
              );
            },
            child: const Text('SCÉNA'),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToVictim(context);
            },
            child: const Text('OBEŤ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NpcListScreen()),
              );
            },
            child: const Text('PODOZRIVÍ'),
          ),
          ElevatedButton(
            onPressed: () {
              _logout();
            },
            child: const Text('ZAUJÍMAVOSTI'),
          ),
        ]
            .map(
              (e) => Padding(
                  child: e, padding: const EdgeInsets.symmetric(vertical: 5)),
            )
            .toList());
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
