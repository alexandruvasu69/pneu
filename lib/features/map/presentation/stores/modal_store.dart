import 'package:flutter/material.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/route.dart' as r;
import 'package:pneu/features/map/domain/usecases/get_calculated_routes.dart';

class ModalStore extends ChangeNotifier {
  ModalStore();

  String? _infoText;
  bool _isActive = false;

  bool get isActive => _isActive;
  String? get infoText => _infoText;

  void openModalForInfo(String text) {
    _isActive = true;
    _infoText = text;
    notifyListeners();
  }

  void openModalForWarning(AppException e) {
    _isActive = true;
    _infoText = e.message;
    notifyListeners();
  }

  void closeModal() {
    _isActive = false;
    _infoText = null;
    notifyListeners();
  }
}
