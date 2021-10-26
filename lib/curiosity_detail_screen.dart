import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Curiosity.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class CuriosityDetailScreen extends StatelessWidget {
  const CuriosityDetailScreen(this.user, this.curiosity);

  final LoggedUser user;
  final Curiosity curiosity;
  final imageWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(user?.name ?? "")),
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
            ),
            child: getScrollView()));
  }

  Widget getScrollView() {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                      image:
                          AssetImage('images/curiosities/${curiosity.picture}'),
                      height: imageWidth,
                      width: imageWidth),
                ),
                SizedBox(height: 20),
                Text(
                  curiosity.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  curiosity.description,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ))
    ]);
  }
}

class CuriosityState extends StatefulWidget {
  const CuriosityState(this.curiosity);

  final Curiosity curiosity;

  @override
  _CuriosityStateState createState() => _CuriosityStateState();
}

class _CuriosityStateState extends State<CuriosityState> {
  DatabaseReference itemref;
  Curiosity curiosity;
  LoggedUser user;

  @override
  void initState() {
    super.initState();
    curiosity = widget.curiosity;
    itemref = FirebaseDatabase.instance.reference().child("CURIOSITIES");
    itemref.onChildChanged.listen(_onEntryChanged);
    _loadUserAndState();
  }

  _onEntryChanged(Event event) {
    if (widget.curiosity.key == event.snapshot.key) {
      if (mounted) {
        setState(() {
          curiosity = Curiosity.fromSnapshot(event.snapshot);
        });
      }
    }
  }

  void _loadUserAndState() async {
    var logged = await MySharedPreferences.getLoggedUser();
    if (mounted) {
      setState(() {
        user = logged;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CuriosityDetailScreen(user, curiosity);
  }
}
