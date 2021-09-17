import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:murdermystery2021/login/login_screen.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:murdermystery2021/npc_list_screen.dart';
import 'package:murdermystery2021/utils/MySharedPreferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          projectId: "murdermystery-2021",
          appId: "1:567967765714:android:3873520773383c98e5490b",
          apiKey: "AIzaSyBBYWNuclIl180RSrLXn9Bcs_sllElZB4Q",
          databaseURL:
              "https://murdermystery-2021-default-rtdb.europe-west1.firebasedatabase.app",
          messagingSenderId: "567967765714"));
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murder Mystery 2021',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PopCult murder mystery 2021'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoggedUser loggedUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getWelcomeString()),
      ),
      resizeToAvoidBottomPadding: false,
      body:
          _getScreenForUser(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getScreenForUser() {
    if (loggedUser == null) {
      return LoginScreen(userChanged: _userChanged);
    } else {
      return NpcListScreen(userChanged: _userChanged);
    }
  }

  _userChanged(LoggedUser user) {
    setState(() {
      loggedUser = user;
    });
  }

  Future<void> _loadUser() async {
    var user = await MySharedPreferences.getLoggedUser();
    setState(() {
      loggedUser = user;
    });
  }

  String getWelcomeString() {
    if (loggedUser == null) {
      return widget.title;
    } else {
      return 'Vitaj ${loggedUser.key}';
    }
  }
}
