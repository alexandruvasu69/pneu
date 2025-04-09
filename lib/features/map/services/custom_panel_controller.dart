import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomPanelController extends PanelController {
  CustomPanelController._internal();
  static final CustomPanelController _instance = CustomPanelController._internal();

  static CustomPanelController get instance => _instance;

  void snapPanelToPoint(double point) {
    _instance.animatePanelToPosition(point);
  }
}
