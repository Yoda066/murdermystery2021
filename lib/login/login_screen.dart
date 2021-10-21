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
          child: TextField(
            decoration: InputDecoration(
              hintText: "napr: POPCULT",
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
            maxLength: 16,
          ),
        ),
        Expanded(child: SizedBox(), flex: 1),
        ElevatedButton(
          onPressed: () {
            _loginAsPlayer(context);
          },
          child: const Text('POKRAČOVAŤ'),
        ),
        Expanded(child: SizedBox(), flex: 3),
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
