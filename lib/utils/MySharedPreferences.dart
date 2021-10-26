import 'dart:convert';

import 'package:murdermystery2021/models/QuizState.dart';
import 'package:murdermystery2021/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static Future<LoggedUser> getLoggedUser() async {
    final pref = await SharedPreferences.getInstance();
    var jsonString = pref.getString('loggedUser');
    if (jsonString == null) {
      return null;
    }
    return LoggedUser.fromJson(jsonDecode(jsonString));
  }

  static Future<bool> setLoggedUser(LoggedUser user) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString('loggedUser', jsonEncode(user));
  }

  static Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove('loggedUser');
  }

  static Future<bool> setSeenWelcomeScreen(bool seenWelcome) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool('seenWelcome', seenWelcome);
  }

  static Future<bool> getSeenWelcome() async {
    final pref = await SharedPreferences.getInstance();
    bool result = pref.getBool('seenWelcome');
    return (result != null && result);
  }

  static Future<bool> setQuizState(QuizState state) async {
    final pref = await SharedPreferences.getInstance();
    print('setting: ${state.index}');
    return await pref.setInt('quizState', state.index);
  }

  static Future<QuizState> getQuizState() async {
    final pref = await SharedPreferences.getInstance();
    int index = pref.getInt('quizState') ?? 0;
    print('getting: $index');
    return (QuizState.values.elementAt(index));
  }
}
