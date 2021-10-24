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
  var tabConstroller;

  var page = 0;

  @override
  void initState() {
    super.initState();
    tabConstroller = TabController(length: 1, vsync: this);
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
        tabConstroller = TabController(length: questions.length, vsync: this);
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
    return Scaffold(
        appBar: AppBar(
          title: Text(loggedUser?.name ?? ""),
        ),
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
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
                ]))));
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
    var i = 1;
    return Expanded(
        child: PageView(
            onPageChanged: setPageState,
            controller: pageController,
            children: questions
                .map((e) => Column(children: [
                      Text(
                        "Otázka č. ${i++}:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(e, style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Odpoveď...",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          ))
                    ]))
                .toList()));
  }

  getNextButton() {
    if (page == questions.length - 1) {
      return ElevatedButton(
          onPressed: () {
            sendResult();
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

  void sendResult() async {
    var result = Map<String, dynamic>();
    result.putIfAbsent("q1", () => "answer");

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
