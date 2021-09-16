import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';

class NpcDetailPage extends StatelessWidget {
  final Npc npc;

  final imageWidth = 200.0;

  NpcDetailPage(this.npc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),
        ),
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
