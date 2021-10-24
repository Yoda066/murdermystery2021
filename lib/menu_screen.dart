import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/npc_detail_screen.dart';
import 'package:murdermystery2021/npc_list/npc_list_screen.dart';
import 'package:murdermystery2021/quiz/quiz_screen.dart';
import 'package:murdermystery2021/scnene_screen.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class MenuScreen extends StatelessWidget {
  final userChanged;
  final LoggedUser loggedUser;

  MenuScreen({this.userChanged, this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            getMainMenu(context),
            Expanded(child: SizedBox(), flex: 2),
            getSolveButton(context),
            Expanded(child: SizedBox(), flex: 1),
          ],
        ),
      ),
    );
  }

  Widget getMainMenu(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SceneScreen()),
              );
            },
            child: const Text('SCÉNA'),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToVictim(context);
            },
            child: const Text('OBEŤ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NpcListScreen()),
              );
            },
            child: const Text('PODOZRIVÍ'),
          ),
          ElevatedButton(
            onPressed: () {
              _logout();
            },
            child: const Text('ODHLÁSIŤ'),
          ),
        ]
            .map(
              (e) => Padding(
                  child: e, padding: const EdgeInsets.symmetric(vertical: 5)),
            )
            .toList());
  }

  Widget getSolveButton(BuildContext context) {
    if (loggedUser.type == UserType.PLAYER) {
      return ElevatedButton(
        onPressed: () {
          solveCase(context);
        },
        child: const Text('VYRIEŠIŤ'),
      );
    }
    return SizedBox();
  }

  void _logout() async {
    await MySharedPreferences.logout();
    userChanged(null);
  }

  void solveCase(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Vyriešiť prípad?"),
              content: Text(
                  'Pozor, chystáte sa ukončiť hru. Pre vyriešenie prípadu musíte zodpovedať záverečné otázky a obviniť jedného alebo viac vypočutých podozrivých. \nNa zodpovedanie otázok máte iba jeden pokus, preto si svojím riešením musíte byť istí. \n\nChcete zadať riešenie?'),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: (Text("Nie"))),
                TextButton(
                    onPressed: () => _navigateToQuiz(context),
                    child: (Text("Áno")))
              ],
            ));
  }

  void _navigateToQuiz(BuildContext context) async {
    Navigator.of(context).pop();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen()),
    );
  }

  void _navigateToVictim(BuildContext context) async {
    var itemref = FirebaseDatabase.instance.reference().child("VICTIM");
    await itemref.once().then((DataSnapshot dataSnapshot) async {
      var npc = Npc.fromSnapshot(dataSnapshot);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NpcState(npc)),
      );
    });
  }

  Future<LoggedUser> loadUser() async {
    return await MySharedPreferences.getLoggedUser();
  }
}
