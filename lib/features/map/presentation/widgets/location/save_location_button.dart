import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:provider/provider.dart';

class SaveLocationButton extends StatelessWidget {
  const SaveLocationButton(
      {super.key, required this.location, this.isRouteDestination = false});
  final Location location;
  final bool isRouteDestination;

  @override
  Widget build(BuildContext context) {
    final savedLocationStore = context.read<SavedLocationsStore>();

    return !savedLocationStore.isLocationSaved(location)
        ? IconButton(
            onPressed: () {
              final currentUser = context.read<UserNotifier>().user;

              if (currentUser != null) {
                context
                    .read<SavedLocationsStore>()
                    .saveLocation(location, currentUser);
              }
            },
            icon: SvgPicture.asset('assets/icons/Heart.svg'),
            highlightColor: Colors.transparent,
          )
        : IconButton(
            onPressed: () {
              savedLocationStore.unsaveLocation(location!);
            },
            icon: SvgPicture.asset('assets/icons/SaveFavorite.svg'),
            highlightColor: Colors.transparent,
          );
  }
}
