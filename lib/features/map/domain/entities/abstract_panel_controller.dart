abstract class AbstractPanelController {
  bool get isPanelAtached;
  void animatePanelToPosition(double position);
  void openPanel();
  void closePanel();
  Object getPanel();
}
