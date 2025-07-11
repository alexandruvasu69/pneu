import 'package:flutter/material.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
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
    final panelStore = context.watch<PanelStore>();
    final eventsStore = context.read<EventsStore>();

    !panelStore.isPanelClosed ? isGeneralActionButtonActive = false : null;

    return Column(
      children: <Widget>[
        ...(isGeneralActionButtonActive)
            ? <Widget>[
                DelayedAnimatedButton(
                  delay: const Duration(milliseconds: 150),
                  child: MoreButton(
                    assetLocation: 'assets/icons/MoreEvents.svg',
                    onTap: () async {
                      PanelStore panelStore = context.read<PanelStore>();
                      await eventsStore.getPendingEvents();
                      panelStore.snapPanel(PanelContentType.events);
                    },
                    buttonWidth: 80,
                    buttonHeight: 40,
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimatedButton(
                  delay: Duration(milliseconds: 100),
                  child: SpecificActionButton(
                    category: 1,
                    assetLocation: 'assets/icons/Attention.svg',
                    iconWidth: 60,
                    iconHeight: 60,
                    onTap: () => handleGeneralActionButtonClick(context),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimatedButton(
                  delay: Duration(milliseconds: 50),
                  child: SpecificActionButton(
                    category: 6,
                    assetLocation: 'assets/icons/NoAccess.svg',
                    iconWidth: 48,
                    iconHeight: 48,
                    onTap: () => handleGeneralActionButtonClick(context),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimatedButton(
                  delay: Duration(milliseconds: 0),
                  child: SpecificActionButton(
                    category: 3,
                    assetLocation: 'assets/icons/StoppedCar.svg',
                    iconWidth: 60,
                    iconHeight: 38,
                    onTap: () => handleGeneralActionButtonClick(context),
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
