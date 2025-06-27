import 'package:pneu/features/map/domain/entities/abstract_panel_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelController implements AbstractPanelController {
  SlidingPanelController(this.panelController);
  PanelController panelController;

  @override
  void animatePanelToPosition(double position) {
    panelController.animatePanelToPosition(position);
  }

  @override
  void closePanel() {
    panelController.close();
  }

  @override
  bool get isPanelAtached => panelController.isAttached;

  @override
  void openPanel() {
    panelController.open();
  }

  @override
  Object getPanel() {
    return panelController;
  }

  PanelController? getPanelInstance() {
    return panelController;
  }
}
