import 'package:flutter/material.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/data/models/event_model.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/stores/user_store.dart';
import 'package:pneu/shared/widgets/buttons/custom_icon_button.dart';
import 'package:provider/provider.dart';

class SpecificActionButton extends StatelessWidget {
  SpecificActionButton({
    super.key,
    required this.assetLocation,
    required this.iconWidth,
    required this.iconHeight,
    required this.category,
    required this.onTap,
  });
  final int category;
  final String assetLocation;
  final double iconWidth;
  final double iconHeight;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () async {
        CustomLatLng currentPosition =
            context.read<PositionStore>().currentPosition!;

        final userId = context.read<UserNotifier>().user!.id;

        await context.read<EventsStore>().addEvent(currentPosition.latitude,
            currentPosition.longitude, category, userId, '');

        print("ON TAP");
        onTap();
      },
      assetLocation: assetLocation,
      buttonWidth: 80,
      buttonHeight: 80,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      padding: const Padding(padding: EdgeInsets.all(10)),
      backgroundColor: Colors.white,
    );
  }
}
