import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/enums/panel_content_type.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/panel_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/route_store.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:pneu/features/map/presentation/widgets/location/location_card.dart';
import 'package:provider/provider.dart';

class SavedLocationsTab extends StatelessWidget {
  SavedLocationsTab({super.key, this.scrollController});
  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final savedLocationsStore = context.watch<SavedLocationsStore>();
    final positionStore = context.watch<PositionStore>();
    final panelStore = context.read<PanelStore>();

    return ListView.separated(
      padding: EdgeInsets.only(
        bottom: BarDimensions.closedPanelHeight +
            MediaQuery.of(context).padding.bottom +
            16,
      ),
      controller: scrollController,
      itemCount: savedLocationsStore.savedLocations.length,
      itemBuilder: (BuildContext context, int index) {
        final loc = savedLocationsStore.savedLocations[index];
        return LocationCard(
          location: loc,
          onTap: () async {
            context.read<LocationPopupStore>().selectedLocation = loc;

            await context.read<RouteStore>().fetchRoutes(
                positionStore.currentPosition!.latitude,
                positionStore.currentPosition!.longitude,
                loc.latitude!,
                loc.longitude!);

            await context
                .read<MapStore>()
                .drawRoutes(context.read<RouteStore>().routeOptions!);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 5,
        );
      },
    );
  }
}
