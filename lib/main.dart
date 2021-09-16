import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/npc_list_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          projectId: "murdermystery-2021",
          appId: "1:567967765714:android:3873520773383c98e5490b",
          apiKey: "AIzaSyBBYWNuclIl180RSrLXn9Bcs_sllElZB4Q",
          databaseURL: "https://murdermystery-2021-default-rtdb.europe-west1.firebasedatabase.app",
          messagingSenderId: "567967765714"));
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murder Mystery 2021 test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PopCult murder mystery 2021'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference itemref;
  var locations = List();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    itemref = FirebaseDatabase.instance.reference().child("NPCS");
    print(FirebaseFirestore.instance.collection("NPCS").get());
    itemref.onChildAdded.listen(_onEntryAdded);
    itemref.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryChanged(Event event) {
    var old = locations.singleWhere((element) {
      return element.key == event.snapshot.key;
    });

    setState(() {
      locations[locations.indexOf(old)] = Npc.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      locations.add(Npc.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: FirebaseAnimatedList(
          query: itemref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return NpcListItem(Npc.fromSnapshot(snapshot));
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
