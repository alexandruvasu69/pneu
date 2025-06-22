import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pneu/shared/models/users/AppUser.dart';
import 'package:pneu/shared/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStore extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final UserService _userService = UserService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false; // dacă e logat cu cont personal
  bool get isAuthenticated => _isAuthenticated;

  AppUser? _currentUser;

  // Gettere;
  AppUser? get currentUser => _currentUser;

  UserStore({required this.sharedPreferences});

  Future<void> loadInitialUser() async {
    print("LOADING USER INFORMATION");
    final String? savedUser = sharedPreferences.getString("app_user");
    print("SAVED USER: $savedUser");
    if (savedUser != null) {
      final Map<String, dynamic> userMap = jsonDecode(savedUser);
      _currentUser = AppUser.fromJson(userMap);
    } else {
      _currentUser = await _userService.getOrCreateGuestUser();
      await _saveUserToPrefs(_currentUser!);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveUserToPrefs(AppUser user) async {
    final jsonString = user.toJson();
    await sharedPreferences.setString('app_user', jsonEncode(jsonString));
  }

  /// Creare cont nou (Signup). Primește email + parola.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _userService.signUp(email: email, password: password);

      await _saveUserToPrefs(_currentUser!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    print("SIGNING IN...");

    try {
      _currentUser = await _userService.signIn(email: email, password: password);

      await _saveUserToPrefs(_currentUser!);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
