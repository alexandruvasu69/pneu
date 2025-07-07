import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/abstract_panel_controller.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';

class PanelStore extends ChangeNotifier {
  AbstractPanelController? panelController;
  bool _isPanelLocked = false;
  double _position = 0;

  PanelContentType _panelContentType = PanelContentType.locations;

  double get position => _position;
  set position(double position) {
    _position = position;
    notifyListeners();
  }

  bool get isPanelClosed => _position == 0;

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

  Future<void> closePanel() async {
    _isPanelLocked = false;
    notifyListeners();
    await panelController?.closePanel();
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
