import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/abstract_panel_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';

class PanelStore extends ChangeNotifier {
  AbstractPanelController? panelController;
  bool _isPanelLocked = false;
  double _position = 0;
  bool _isPanelOpening = false;

  PanelContentType _panelContentType = PanelContentType.locations;

  double get position => _position;
  set position(double position) {
    _position = position;
    notifyListeners();
  }

  bool get isPanelClosed => _position == 0;

  bool get isPanelOpening => _isPanelOpening;
  set isPanelOpening(bool isOpening) {
    _isPanelOpening = isOpening;
    notifyListeners();
  }

  bool get isPanelLocked => _isPanelLocked;
  PanelContentType get panelContentType => _panelContentType;

  Future<void> snapPanel(
      [PanelContentType panelContentType = PanelContentType.locations]) async {
    print("OPEN PANEL: ${position}");
    _panelContentType = panelContentType;
    notifyListeners();
    await panelController?.animatePanelToPosition(panelContentType.snapPoint);
    _isPanelLocked = panelContentType.isLocked;

    notifyListeners();
  }

  Future<void> closePanel({bool onPanelClosed = false}) async {
    _isPanelLocked = false;
    notifyListeners();

    if (!onPanelClosed) {
      await panelController?.closePanel();
    }
    _panelContentType = PanelContentType.locations;

    notifyListeners();
  }

  Future<void> openPanel(
      [PanelContentType panelContentType = PanelContentType.locations]) async {
    await panelController?.openPanel();
    notifyListeners();
  }

  void initController(AbstractPanelController panelController) {
    this.panelController = panelController;
    notifyListeners();
  }
}
