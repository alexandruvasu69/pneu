import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/domain/usecases/get_user.dart';
import 'package:pneu/features/login/domain/usecases/log_out.dart';
import 'package:pneu/features/login/domain/usecases/login.dart';
import 'package:pneu/features/login/domain/usecases/register.dart';
import 'package:pneu/features/login/domain/usecases/update_user_role.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';

class UserNotifier extends ChangeNotifier {
  UserNotifier({
    required this.getUser,
    required this.login,
    required this.register,
    required this.updateUserRole,
    required this.logOut,
    required SavedLocationsStore savedLocationsStore,
  }) : _savedLocationsStore = savedLocationsStore;

  final GetUser getUser;
  final Login login;
  final Register register;
  final SavedLocationsStore _savedLocationsStore;
  final UpdateUserRole updateUserRole;
  final LogOut logOut;

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

      if (_currentUser != null) {
        print("CURRENT USER: ${_currentUser?.id}");
        if (!(_currentUser!.isGuest))
          _currentUser = await updateUserRole(_currentUser!);

        await _savedLocationsStore.getSavedLocations(_currentUser!);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await register(email, password);
      if (_currentUser != null) {
        await _savedLocationsStore.getSavedLocations(_currentUser!);
      }
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
      if (_currentUser != null) {
        if (!(_currentUser!.isGuest))
          _currentUser = await updateUserRole(_currentUser!);

        await _savedLocationsStore.getSavedLocations(_currentUser!);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await logOut();

      await _savedLocationsStore.getSavedLocations(_currentUser!);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
