import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPrefDataSource {
  static const _key = 'app_user';

  Future<Map<String, dynamic>?> getUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? savedUser = sharedPreferences.getString(_key);

    if (savedUser != null) {
      return jsonDecode(savedUser);
    } else {
      return null;
    }
  }

  Future<void> saveUser(Map<String, dynamic> userJson) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userJson);

    await sharedPreferences.setString(_key, jsonString);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
