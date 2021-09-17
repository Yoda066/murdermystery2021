import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class LoginScreen extends StatelessWidget {
  final userChanged;

  LoginScreen({this.userChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        RaisedButton(
          onPressed: () {
            _loginAsNpc(context);
          },
          child: const Text('login as NPC'),
        ),
        const SizedBox(height: 30),
        RaisedButton(
          onPressed: () {
            _loginAsPlayer(context);
          },
          child: const Text('login as player'),
        )
      ]),
    );
  }

  _loginAsPlayer(BuildContext context) {
    var user = new LoggedUser('Team1', UserType.PLAYER);
    MySharedPreferences.setLoggedUser(user);
    userChanged(user);
  }

  _loginAsNpc(BuildContext context) {
    var user = new LoggedUser('Tobik', UserType.NPC);
    MySharedPreferences.setLoggedUser(user);
    userChanged(user);
  }
}
