import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/curiosity_list/curiosity_list_screen.dart';
import 'package:murdermystery2021/models/Npc.dart';
import 'package:murdermystery2021/models/QuizState.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/npc_detail_screen.dart';
import 'package:murdermystery2021/npc_list/npc_list_screen.dart';
import 'package:murdermystery2021/quiz/quiz_screen.dart';
import 'package:murdermystery2021/scnene_screen.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class MenuScreen extends StatefulWidget {
  final userChanged;

  MenuScreen({this.userChanged});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuScreen> {
  bool quizAvailable = false;
  LoggedUser loggedUser;
  QuizState quizState;

  @override
  void initState() {
    FirebaseDatabase.instance
        .reference()
        .child("QUIZ_AVAILABLE")
        .onValue
        .listen((event) {
      setState(() {
        quizAvailable = event.snapshot.value;
      });
    });
    super.initState();

    loadUser();
  }

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
            child: const Text('SC??NA'),
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToVictim(context);
            },
            child: const Text('OBE??'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NpcListScreen()),
              );
            },
            child: const Text('PODOZRIV??'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CuriosityListScreen()),
              );
            },
            child: const Text('ZAUJ??MAVOSTI'),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     _logout();
          //   },
          //   child: const Text('ODHL??SI??'),
          // ),
        ]
            .map(
              (e) => Padding(
                  child: e, padding: const EdgeInsets.symmetric(vertical: 5)),
            )
            .toList());
  }

  Widget getSolveButton(BuildContext context) {
    if (loggedUser?.type == UserType.PLAYER) {
      return ElevatedButton(
        onPressed: () {
          solveCase(context);
        },
        child: const Text('VYRIE??I??'),
      );
    }
    return SizedBox();
  }

  void _logout() async {
    await MySharedPreferences.logout();
    if (widget.userChanged != null) {
      widget.userChanged(null);
    }
  }

  void solveCase(BuildContext context) {
    if (quizState == QuizState.DONE) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Vyrie??i?? pr??pad?"),
                content: Text('Va??e odpovede boli odoslan?? na vyhodnotenie.'),
                actions: [
                  TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: (Text("OK"))),
                ],
              ));
    } else if (!quizAvailable) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Vyrie??i?? pr??pad?"),
                content: Text('Vyrie??enie pr??padu zatia?? nie je k dispoz??cii.'),
                actions: [
                  TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: (Text("OK"))),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Vyrie??i?? pr??pad?"),
                content: Text(
                    'Pozor, chyst??te sa ukon??i?? hru. Pre vyrie??enie pr??padu mus??te zodpoveda?? z??vere??n?? ot??zky a obvini?? jedn??ho alebo viac vypo??ut??ch podozriv??ch. \nNa zodpovedanie ot??zok m??te iba jeden pokus, preto si svoj??m rie??en??m mus??te by?? ist??. \n\nChcete zada?? rie??enie?'),
                actions: [
                  TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: (Text("Nie"))),
                  TextButton(
                      onPressed: () => _navigateToQuiz(context),
                      child: (Text("??no")))
                ],
              ));
    }
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
    var user = await MySharedPreferences.getLoggedUser();
    var quizStat = await MySharedPreferences.getQuizState();

    if (quizStat == QuizState.STARTED) {
      _navigateToQuiz(context);
    } else {
      setState(() {
        loggedUser = user;
        quizState = quizStat;
      });
    }
  }
}
