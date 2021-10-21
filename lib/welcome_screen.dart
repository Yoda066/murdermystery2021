import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            // _loginAsPlayer(context);
          },
          child: Text('Pokračovať'),
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
