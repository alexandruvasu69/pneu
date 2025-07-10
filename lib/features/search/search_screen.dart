import 'package:flutter/material.dart';
import 'package:pneu/features/login/presentation/notifiers/user_notifier.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/presentation/stores/search_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/widgets/custom_search_bar.dart';
import 'package:pneu/features/map/presentation/widgets/location/location_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search';
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchStore = context.watch<SearchStore>();
    final userStore = context.watch<UserNotifier>();
    final locationPopupStore = context.read<LocationPopupStore>();
    final mapStore = context.read<MapStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 26, vertical: 0),
            child: SizedBox(
              height: 50,
              child: CustomSearchBar(
                isInMainScreen: false,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchStore.suggestedLocations.length,
              itemBuilder: (context, index) {
                final location = searchStore.suggestedLocations[index];
                return LocationCard(
                  location: location,
                  onTap: () async {
                    Navigator.of(context).pop();
                    final retrievedLocation = await searchStore
                        .retrieveLocation(location.id, userStore.user!);
                    print(
                        "RETRIEVED LOCATION : ${retrievedLocation.address1}, ${retrievedLocation.address2}, ${retrievedLocation.latitude}, ${retrievedLocation.longitude}");
                    mapStore.centerMapOnLocationPopupWithLocation(
                        retrievedLocation);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
