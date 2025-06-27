import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/abstract_panel_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';

class PanelStore extends ChangeNotifier {
  AbstractPanelController? panelController;

  bool _isPanelOpen = false;
  bool _isPanelSnapped = false;
  bool _isOpening = false;
  bool _isClosing = false;
  double _position = 0;
  bool _openPanel = false;
  PanelContentType _panelContentType = PanelContentType.locations;

  bool get isPanelOpen => _isPanelOpen;
  bool get isPanelSnapped => _isPanelSnapped;
  bool get isOpening => _isOpening;
  bool get isClosing => _isClosing;
  double get position => _position;
  bool get openPanel => _openPanel;
  PanelContentType get panelContentType => _panelContentType;

  set isPanelOpen(bool value) {
    _isPanelOpen = value;
    notifyListeners();
  }

  set isPanelSnapped(bool value) {
    _isPanelSnapped = value;
    notifyListeners();
  }

  set isOpening(bool value) {
    _isOpening = value;
    notifyListeners();
  }

  set isClosing(bool value) {
    _isClosing = value;
    notifyListeners();
  }

  set position(double position) {
    _position = position;
    notifyListeners();
  }

  set panelContentType(PanelContentType value) {
    _panelContentType = value;
    notifyListeners();
  }

  set openPanel(bool value) {
    _openPanel = value;
    notifyListeners();
  }

  void initController(AbstractPanelController panelController) {
    this.panelController = panelController;
    notifyListeners();
  }
}
