import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Npc.dart';

class NpcListItem extends StatelessWidget {
  final Npc npc;

  NpcListItem(this.npc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('clicked on: ' + npc.name);
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 5),
        constraints: BoxConstraints.expand(height: 130),
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Expanded(child: getTitleAndLike()), getImage()],
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
          child: Text(npc.backstory,
              style: TextStyle(fontSize: 15)))
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
              shape: BoxShape.rectangle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ));
  }

  // Widget _buildLikeColumn() {
  //   Color finalColor = (location.likedByMe) ? Colors.pink : Colors.black;
  //
  //   return GestureDetector(
  //       onTap: () {
  //         location.likedByMe = !location.likedByMe;
  //         print('${location.title} liked: ${location.likedByMe}');
  //       },
  //       child: Row(
  //         children: [
  //           Icon(Icons.favorite, color: finalColor),
  //           Container(
  //             margin: const EdgeInsets.only(left: 5),
  //             child: Text(
  //               location.likes.toString(),
  //               style: TextStyle(
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w400,
  //                 color: finalColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  // Future<bool> onLikeButtonTapped(bool isLiked) async {
  //   /// ulozit do db
  //   // DatabaseReference ref = FirebaseDatabase.instance.reference().child("cabins/${location.key}");
  //   // ref.update(value)
  //   // ref.set({
  //   //   username: name,
  //   //   email: email,
  //   //   profile_picture : imageUrl
  //   // });
  //
  //
  //   location.likedByMe = !isLiked;
  //
  //   return !isLiked;
  // }
}
