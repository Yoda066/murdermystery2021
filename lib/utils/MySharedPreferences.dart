import 'dart:convert';

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
}
