import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Scene.dart';

class SceneScreen extends StatefulWidget {
  @override
  _SceneState createState() => _SceneState();
}

class _SceneState extends State<SceneScreen> {
  DatabaseReference itemref;
  Scene scene;

  _SceneState({this.scene});

  @override
  void initState() {
    super.initState();
    itemref =
        FirebaseDatabase.instance.reference().child("SCENES").child("Abarat");
    itemref.onChildChanged.listen(_onEntryChanged);
    itemref.onValue.listen(_onEntryChanged);
  }

  _onEntryChanged(Event event) {
    print(event.snapshot);

    if (mounted) {
      setState(() {
        scene = Scene.fromSnapshot(event.snapshot);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (scene == null) {
      return Text("Loading...", style: TextStyle(fontSize: 15));
    } else {
      return SingleChildScrollView(
          child: Column(children: [
        Image(image: AssetImage('images/scene_back.jpg')),
        Container(
            padding: EdgeInsets.all(15.0),
            child: Column(children: [
              SizedBox(height: 10),
              Text(scene.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(scene.description, style: TextStyle(fontSize: 15))
            ]))
      ]));
    }
  }
}
