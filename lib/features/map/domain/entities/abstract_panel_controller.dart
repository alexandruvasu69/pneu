abstract class AbstractPanelController {
  bool get isPanelAtached;
  Future<void> animatePanelToPosition(double position);
  Future<void> openPanel();
  Future<void> closePanel();
  double get panelPosition;
  Object getPanel();
}
