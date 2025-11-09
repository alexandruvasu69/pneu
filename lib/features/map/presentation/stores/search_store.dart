import 'package:flutter/material.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/usecases/retrieve_location.dart';
import 'package:pneu/features/map/domain/usecases/suggest_location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class SearchStore extends ChangeNotifier {
  SearchStore(
      {required SuggestLocation suggestLocation,
      required RetrieveLocation retrieveLocation})
      : _suggestLocation = suggestLocation,
        _retrieveLocation = retrieveLocation;

  SuggestLocation _suggestLocation;
  RetrieveLocation _retrieveLocation;

  List<Location> suggestedLocations = List.empty(growable: true);

  Future<void> suggestLocations(
      String location, User user, CustomLatLng position) async {
    suggestedLocations.clear();
    print("SEARCHED LOCATION: $location");
    if (location.isNotEmpty) {
      final locations = await _suggestLocation(location, user, position);
      suggestedLocations.addAll(locations);
    }
    notifyListeners();
  }

  Future<Location> retrieveLocation(String id, User user) async {
    final Location location = await _retrieveLocation(id, user);

    return location;
  }
}
