import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
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
  bool showedWelcome = true;

  @override
  void initState() {
    super.initState();
    itemref = FirebaseDatabase.instance.reference().child("TEAMS");
    _seenWelcome();
  }

  @override
  Widget build(BuildContext context) {
    return getScreen();
  }

  _login(BuildContext context, String name) async {
    if (name == "MegaAdmin") {
      _loginAsAdmin(context);
      return;
    }

    //checknem ci prihlasovacie meno zodpoveda klucu nejakej NPC
    await FirebaseDatabase.instance
        .reference()
        .child("NPCS")
        .child(name)
        .once()
        .then((DataSnapshot dataSnapshot) async {
      var npc = dataSnapshot.value as Map;

      if (npc != null) {
        _loginAsNpc(context, name, npc['name']);
      } else {
        _loginAsPlayer(context, name);
      }
    });
  }

  void _seenWelcome() async {
    var seen = await MySharedPreferences.getSeenWelcome();
    if (mounted) {
      setState(() {
        showedWelcome = seen;
      });
    }
  }

  void goToLogin() async {
    await MySharedPreferences.setSeenWelcomeScreen(true);
    setState(() {
      showedWelcome = true;
    });
  }

  _loginAsNpc(BuildContext context, String key, String name) async {
    var user = new LoggedUser(key, name, UserType.NPC);
    await MySharedPreferences.setLoggedUser(user);
    widget.userChanged(user);
  }

  _loginAsAdmin(BuildContext context) async {
    var user = new LoggedUser("key", "O Velectený", UserType.ADMIN);
    await MySharedPreferences.setLoggedUser(user);
    widget.userChanged(user);
  }

  void _loginAsPlayer(BuildContext context, String name) async {
    //create and save user if doesnt exists
    await itemref.once().then((DataSnapshot dataSnapshot) async {
      var t = dataSnapshot.value as Map;
      var selectedTeam = t.entries
          .firstWhereOrNull((element) => element.value['name'] == name);

      var user;
      if (selectedTeam == null) {
        var newteam = itemref.push();
        newteam.update({
          'name': name,
        });

        user = new LoggedUser(newteam.key, name, UserType.PLAYER);
      } else {
        user = new LoggedUser(selectedTeam.key, name, UserType.PLAYER);
      }

      MySharedPreferences.setLoggedUser(user);
      widget.userChanged(user);
    });
  }

  Widget getScreen() {
    if (showedWelcome) {
      return getLoginScreen();
    } else {
      return getWelcomeScreen();
    }
  }

  Widget getLoginScreen() {
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

  Widget getWelcomeScreen() {
    return Center(
        child: Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 60),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(flex: 1, child: SizedBox()),
        Image(image: AssetImage('images/ikona.png'), width: 150.0),
        const SizedBox(height: 20),
        Text('Vitajte detektívi!', style: TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Text(
                'V mestečku Silvertown sa našla mŕtvola šerifa Jenkinsa. Podarí sa vám odhaliť tajomstvá mesta a dolapiť vraha?',
                textAlign: TextAlign.center)),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            goToLogin();
          },
          child: Text('POKRAČOVAŤ'),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Text(
          'Užite si detektívnu hru, ktorú pre vás pripravil PoP-Cult. \nwww.popcult.sk',
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ]),
    ));
  }
}
