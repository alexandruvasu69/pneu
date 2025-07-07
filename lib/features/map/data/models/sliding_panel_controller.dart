import 'package:pneu/features/map/domain/entities/abstract_panel_controller.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelController implements AbstractPanelController {
  SlidingPanelController(this.panelController);
  PanelController panelController;

  @override
  Future<void> animatePanelToPosition(double position) async {
    await panelController.animatePanelToPosition(position);
  }

  @override
  Future<void> closePanel() async {
    await panelController.close();
  }

  @override
  bool get isPanelAtached => panelController.isAttached;

  @override
  Future<void> openPanel() async {
    await panelController.open();
  }

  @override
  Object getPanel() {
    return panelController;
  }

  PanelController? getPanelInstance() {
    return panelController;
  }

  @override
  double get panelPosition => panelController.panelPosition;
}
