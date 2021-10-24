import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:murdermystery2021/login/login_screen.dart';
import 'package:murdermystery2021/menu_screen.dart';
import 'package:murdermystery2021/models/User.dart';
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

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

const MaterialColor kPrimaryColor = const MaterialColor(
  0xFF221c13,
  const <int, Color>{
    50: const Color(0xFF221c13),
    100: const Color(0xFF221c13),
    200: const Color(0xFF221c13),
    300: const Color(0xFF221c13),
    400: const Color(0xFF221c13),
    500: const Color(0xFF221c13),
    600: const Color(0xFF221c13),
    700: const Color(0xFF221c13),
    800: const Color(0xFF221c13),
    900: const Color(0xFF221c13),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murder Mystery 2021',
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.roboto().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                textStyle:
                    GoogleFonts.roboto(color: Colors.white, fontSize: 20))),
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
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/pozadie.png"), fit: BoxFit.cover),
            ),
            child: Container(
                padding: EdgeInsets.all(15), child: _getScreenForUser()))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget _getScreenForUser() {
    if (loggedUser == null) {
      // return WelcomeScreen();
      return LoginScreen(userChanged: _userChanged);
    } else {
      //do the menu
      return MenuScreen(
        userChanged: _userChanged,
        loggedUser: loggedUser,
      );
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
      return 'Vitaj ${loggedUser.name}';
    }
  }
}
