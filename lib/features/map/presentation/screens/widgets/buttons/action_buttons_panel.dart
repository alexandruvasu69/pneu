import 'package:flutter/material.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons/general_action_button.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons/more_button.dart';
import 'package:pneu/features/map/presentation/widgets/buttons/action_buttons/specific_action_button.dart';
import 'package:pneu/shared/widgets/buttons/delayed_animated_button.dart';
import 'package:provider/provider.dart';

class ActionButtonsPanel extends StatefulWidget {
  const ActionButtonsPanel({super.key});

  @override
  State<ActionButtonsPanel> createState() => _ActionButtonsPanelState();
}

class _ActionButtonsPanelState extends State<ActionButtonsPanel> {
  bool isGeneralActionButtonActive = false;

  void handleGeneralActionButtonClick(BuildContext context) {
    setState(() {
      isGeneralActionButtonActive = !isGeneralActionButtonActive;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<PanelStore>().openPanel
        ? isGeneralActionButtonActive = false
        : null;

    return Column(
      children: <Widget>[
        ...(isGeneralActionButtonActive &&
                !context.watch<PanelStore>().isOpening &&
                !context.watch<PanelStore>().isPanelSnapped)
            ? <Widget>[
                DelayedAnimatedButton(
                  delay: const Duration(milliseconds: 150),
                  child: MoreButton(
                    assetLocation: 'assets/icons/MoreEvents.svg',
                    onTap: () {
                      PanelStore panelStore = context.read<PanelStore>();

                      panelStore.panelContentType = PanelContentType.events;
                      panelStore.openPanel = true;
                    },
                    buttonWidth: 80,
                    buttonHeight: 40,
                  ),
                ),
                const SizedBox(height: 10),
                const DelayedAnimatedButton(
                  delay: Duration(milliseconds: 100),
                  child: SpecificActionButton(
                    assetLocation: 'assets/icons/Attention.svg',
                    iconWidth: 60,
                    iconHeight: 60,
                  ),
                ),
                const SizedBox(height: 10),
                const DelayedAnimatedButton(
                  delay: Duration(milliseconds: 50),
                  child: SpecificActionButton(
                    assetLocation: 'assets/icons/Speed.svg',
                    iconWidth: 60,
                    iconHeight: 32,
                  ),
                ),
                const SizedBox(height: 10),
                const DelayedAnimatedButton(
                  delay: Duration(milliseconds: 0),
                  child: SpecificActionButton(
                    assetLocation: 'assets/icons/StoppedCar.svg',
                    iconWidth: 60,
                    iconHeight: 38,
                  ),
                ),
                const SizedBox(height: 10),
              ]
            : <Widget>[],
        GeneralActionButton(
          onTap: () => handleGeneralActionButtonClick(context),
          assetLocation: 'assets/icons/BikeEvent.svg',
        ),
      ],
    );
  }
}
