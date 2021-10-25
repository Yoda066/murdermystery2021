import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  DatabaseReference itemref;
  LoggedUser loggedUser;
  var questions = [];
  PageController pageController;
  var page = 0;
  List<String> answers = new List.filled(10, "");

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);

    _loadUser();

    itemref = FirebaseDatabase.instance.reference().child("QUIZ");
    itemref.onValue.listen((event) {
      var snapshot = event.snapshot;

      setState(() {
        questions = [];
        for (var i = 1; i <= snapshot.value.length; i++) {
          questions.add(snapshot.value['q$i']);
        }
      });
    });
  }

  Future<void> _loadUser() async {
    var user = await MySharedPreferences.getLoggedUser();
    setState(() {
      loggedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Nepytal som sa zo srandy. Musite zodpovedat otazky.")));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(loggedUser?.name ?? ""),
            ),
            body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/pozadie.png"),
                      fit: BoxFit.cover),
                ),
                child: Container(
                    padding: EdgeInsets.all(15),
                child: Column(children: [
                  getQuestionsPager(),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          onPressed: () {
                            previousPage();
                              },
                              child: Text('SPÄŤ')),
                        ),
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 20,
                            )),
                        Expanded(flex: 2, child: getNextButton())
                      ])
                    ])))));
  }

  void nextPage() {
    pageController.animateToPage(pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      page = pageController.page.toInt() + 1;
    });
  }

  void previousPage() {
    pageController.animateToPage(pageController.page.toInt() - 1,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      page = pageController.page.toInt() - 1;
    });
  }

  Widget getQuestionsPager() {
    List<Widget> questionWidgets = [];

    for (var i = 0; i < questions.length; i++) {
      var controller = TextEditingController(text: answers[i]);

      questionWidgets.add(Column(children: [
        Text(
          "Otázka č. ${i + 1}:",
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 20,
        ),
        Text(questions[i], style: TextStyle(fontSize: 20)),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              onChanged: (text) {
                answers[i] = text;
                print(answers);
              },
              controller: controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Odpoveď...",
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ))
      ]));
    }

    return Expanded(
        child: PageView(
            onPageChanged: setPageState,
            controller: pageController,
            children: questionWidgets));
  }

  getNextButton() {
    if (page == questions.length - 1) {
      return ElevatedButton(
          onPressed: () {
            showSendDialog();
          },
          child: Text('ODOSLAŤ'));
    } else {
      return ElevatedButton(
          onPressed: () {
            nextPage();
          },
          child: Text('ĎALEJ'));
    }
  }

  void showSendDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Vyriešiť prípad?"),
              content: Text(
                  'Odpovede môžete odoslať iba raz! Ste si istý, že chcete ukončiť hru?'),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: (Text("Ešte nie"))),
                TextButton(
                    onPressed: () =>
                        {Navigator.of(context).pop(), sendResult()},
                    child: (Text("Vyriešiť"))),
              ],
            ));
  }

  void sendResult() async {
    var result = Map<String, dynamic>();

    var i = 1;
    answers.forEach((element) {
      result.putIfAbsent("q${i++}", () => element);
    });

    await FirebaseDatabase.instance
        .reference()
        .child("TEAMS")
        .child(loggedUser.key)
        .update(result);
  }

  void setPageState(int value) {
    setState(() {
      page = value;
    });
  }
}
