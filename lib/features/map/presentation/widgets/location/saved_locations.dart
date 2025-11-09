import 'package:flutter/material.dart';
import 'package:pneu/features/map/presentation/stores/saved_locations_store.dart';
import 'package:provider/provider.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<SavedLocationsStore>();

    if (store.savedLocations.isEmpty) return Text('Nicio locatie');

    return Column(
      children: [
        for (final loc in store.savedLocations) Text(loc.address1),
      ],
    );
  }
}
