import 'package:flutter/material.dart';
import 'package:murdermystery2021/curiosity_detail_screen.dart';
import 'package:murdermystery2021/models/Curiosity.dart';

class CuriosityListItem extends StatelessWidget {
  final Curiosity curiosity;
  static final double height = 150.0;

  CuriosityListItem(this.curiosity);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CuriosityState(curiosity)),
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
            curiosity.title,
            maxLines: 1,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 15),
          Expanded(
              child: Text(curiosity.description ?? "",
                  // maxLines: 5,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 14, color: Colors.white))),
        ],
      ),
    ));
  }

  Widget getImage() {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
        child: Image(
            image: AssetImage('images/curiosities/${curiosity.picture}'),
            height: height));
  }
}
