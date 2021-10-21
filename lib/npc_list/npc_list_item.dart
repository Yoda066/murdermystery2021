import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/npc_detail_screen.dart';

import '../models/Npc.dart';

class NpcListItem extends StatelessWidget {
  final Npc npc;
  static final double height = 150.0;

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
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(0xFF221c13),
            ),
            height: height,
            child: Row(
              children: [getImage(), getInfo()],
            )));
  }

  Widget getInfo() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            npc.name,
            maxLines: 1,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.left,
          ),
          Text(npc.backstory,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.white)),
          getStatus(npc),
        ],
      ),
    ));
  }

  Widget getImage() {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        child: Image(
            image: AssetImage('images/profiles/${npc.image}'), height: height));
  }

  Widget getStatus(Npc npc) {
    if (npc.calledBy == null) {
      return RichText(
          text: TextSpan(
        children: [
          TextSpan(
              text: 'Status: ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
          TextSpan(
              text: 'Dostupný',
              style: TextStyle(fontSize: 15, color: Colors.green)),
        ],
      ));
    } else {
      return RichText(
          text: TextSpan(
        children: [
          TextSpan(
              text: 'Status: ',
              style: TextStyle(fontSize: 15, color: Colors.white)),
          TextSpan(
              text: 'Pri tíme "${npc.calledBy}"',
              style: TextStyle(fontSize: 15, color: Colors.red)),
        ],
      ));
    }
  }
}
