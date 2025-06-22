import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/usecases/get_user.dart';
import 'package:pneu/features/login/domain/usecases/login.dart';
import 'package:pneu/features/login/domain/usecases/register.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier({required this.getUser, required this.login, required this.register});

  final GetUser getUser;
  final Login login;
  final Register register;

  User? _currentUser;
  bool _isLoading = true;
  String? _error;

  User? get user => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadInitialUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await getUser();
    } catch (e) {
      _error = e.toString();
    }

    print(jsonEncode(_currentUser?.toJson()));
    print(_error);

    _isLoading = false;
    notifyListeners();
  }

  /// Creare cont nou (Signup). Primește email + parola.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await register(email, password);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await login(email, password);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
