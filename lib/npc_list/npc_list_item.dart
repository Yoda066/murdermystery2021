import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/npc_detail_screen.dart';

import '../models/Npc.dart';

class NpcListItem extends StatelessWidget {
  final Npc npc;

  NpcListItem(this.npc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NpcState(npc)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 5),
        constraints: BoxConstraints.expand(height: 150),
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: getInfo()),
            const SizedBox(width: 5),
            getImage()
          ],
        ),
      ),
    );
  }

  Widget getInfo() {
    // npc.backstory.split('. ').sublist(0, 5).join(".")+".";

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(npc.name,
              maxLines: 1,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Align(
          alignment: Alignment.topLeft,
          child: Text(npc.backstory,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15))),
      Align(
        alignment: Alignment.topLeft,
        child: getStatus(npc),
      )
    ]);
  }

  Widget getImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image(
            image: AssetImage('images/profiles/${npc.image}'),
            width: 100.0,
            height: 100.0));
  }

  Widget getStatus(Npc npc) {
    if (npc.calledBy == null) {
      return Text('Status: Dostupný',
          maxLines: 2, style: TextStyle(fontSize: 15));
    } else {
      return Text('Status: Zaneprázdnený pri tíme "${npc.calledBy}"',
          maxLines: 2, style: TextStyle(fontSize: 15));
    }
  }
}
