import 'package:flutter/material.dart';
import 'package:pneu/core/themes/app_colors.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:pneu/features/map/presentation/widgets/location/save_location_button.dart';
import 'package:provider/provider.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final bool isRouteDestination;
  final Function()? onTap;

  const LocationCard(
      {super.key,
      required this.location,
      this.isRouteDestination = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final savedLocationStore = context.watch<SavedLocationsStore>();
    final isLocationSaved = savedLocationStore.isLocationSaved(location);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 36),
        decoration: BoxDecoration(
            color: (isLocationSaved || isRouteDestination)
                ? AppColors.secondaryAccent
                : AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SaveLocationButton(
              location: location,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    location?.address1 ?? 'unknown location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: (isLocationSaved || isRouteDestination)
                          ? AppColors.primaryColor
                          : AppColors.secondaryAccent,
                    ),
                  ),
                  Text(
                    location?.address2 ?? 'unknown location',
                    style: TextStyle(
                      fontSize: 14,
                      color: (isLocationSaved || isRouteDestination)
                          ? AppColors.primaryColor
                          : AppColors.secondaryAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
