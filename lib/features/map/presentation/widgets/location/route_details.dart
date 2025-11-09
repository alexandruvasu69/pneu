import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:pneu/features/map/presentation/widgets/location/location_card.dart';
import 'package:provider/provider.dart';

class RouteDetails extends StatelessWidget {
  const RouteDetails({super.key, required this.location});
  final Location? location;

  @override
  Widget build(BuildContext context) {
    void handleOnCancelPress() {
      MapStore mapStore = context.read<MapStore>();
      mapStore.centerMapOnCurrentLocation(
          context.read<PositionStore>().currentPosition!);
      mapStore.clearAllRoutes();
      context.read<PanelStore>().closePanel();
    }

    void handleOnStartPress() {
      context.read<MapStore>().startRoute();

      context.read<PanelStore>().closePanel();
    }

    final savedLocationStore = context.watch<SavedLocationsStore>();

    return Column(
      children: [
        location != null
            ? LocationCard(
                location: location!,
                isRouteDestination: true,
              )
            : SizedBox.shrink(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 46,
          children: <Widget>[
            ElevatedButton(
              onPressed: handleOnCancelPress,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: handleOnStartPress,
              child: const Text('Start'),
            ),
          ],
        ),
      ],
    );
  }
}
