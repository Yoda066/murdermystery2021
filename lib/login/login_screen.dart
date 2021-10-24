import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Team.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.userChanged});

  final userChanged;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  DatabaseReference itemref;
  List<Team> teams;

  @override
  void initState() {
    super.initState();
    itemref = FirebaseDatabase.instance.reference().child("TEAMS");
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController teamNameController = TextEditingController();

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: SizedBox(),
          flex: 3,
        ),
        Text('ZADAJTE NÁZOV VÁŠHO TÍMU', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 10),
        Text(
          'Vyberte si, ako sa bude volať Váš tím. Názov musí byť v rozmedzí 3 - 16 znakov.',
          textAlign: TextAlign.center,
        ),
        Expanded(child: SizedBox(), flex: 1),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
          child: Form(
              key: _formKey,
              child: TextFormField(
                controller: teamNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Zadajte názov tímu';
                  } else if (value.length < 3) {
                    return 'Názov musí obsahovať aspoň 3 znaky';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "napr: POPCULT",
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
                maxLength: 16,
              )),
        ),
        Expanded(child: SizedBox(), flex: 1),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _login(context, teamNameController.value.text);
            }
          },
          child: const Text('POKRAČOVAŤ'),
        ),
        Expanded(child: SizedBox(), flex: 3),
      ]),
    );
  }

  _login(BuildContext context, String name) async {
    //checknem ci prihlasovacie meno zodpoveda klucu nejakej NPC
    await FirebaseDatabase.instance
        .reference()
        .child("NPCS")
        .once()
        .then((DataSnapshot dataSnapshot) async {
      var t = dataSnapshot.value as Map;
      var isNPC = t.keys.firstWhereOrNull((element) => element == name) != null;

      if (isNPC) {
        _loginAsNpc(context, name);
      } else {
        _loginAsPlayer(context, name);
      }
    });
  }

  _loginAsNpc(BuildContext context, String name) {
    var user = new LoggedUser(name, UserType.NPC);
    MySharedPreferences.setLoggedUser(user);
    widget.userChanged(user);
  }

  void _loginAsPlayer(BuildContext context, String name) async {
    //create and save user if doesnt exists
    await itemref.once().then((DataSnapshot dataSnapshot) async {
      var t = dataSnapshot.value as Map;
      var selectedTeam =
          t.values.firstWhereOrNull((element) => element['name'] == name);
      if (selectedTeam == null) {
        var newteam = itemref.push();
        newteam.update({
          'name': name,
        });
      }

      var user = new LoggedUser(name, UserType.PLAYER);
      MySharedPreferences.setLoggedUser(user);
      widget.userChanged(user);
    });
  }
}
