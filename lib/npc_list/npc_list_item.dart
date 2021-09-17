import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/npc_detail_page.dart';

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
        constraints: BoxConstraints.expand(height: 130),
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: getTitleAndLike()),
            const SizedBox(width: 5),
            getImage()
          ],
        ),
      ),
    );
  }

  Widget getTitleAndLike() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(npc.name,
              maxLines: 2,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Align(
          alignment: Alignment.topLeft,
          child:
              Text(npc.backstory, maxLines: 3, style: TextStyle(fontSize: 15)))
    ]);
  }

  Widget getImage() {
    final double imageWidth = 100.0;
    return Container(
        alignment: Alignment.centerRight,
        child: CachedNetworkImage(
          imageUrl: npc.image,
          imageBuilder: (context, imageProvider) => Container(
            height: imageWidth,
            width: imageWidth,
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              shape: BoxShape.rectangle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ));
  }
}
