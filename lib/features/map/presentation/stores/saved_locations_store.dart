import 'package:flutter/material.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/usecases/delete_saved_location.dart';
import 'package:pneu/features/map/domain/usecases/get_saved_locations.dart';
import 'package:pneu/features/map/domain/usecases/save_location.dart';
import 'package:pneu/features/map/presentation/stores/modal_store.dart';
import 'package:pneu/features/login/domain/entities/user.dart';

class SavedLocationsStore extends ChangeNotifier {
  SavedLocationsStore({
    required GetSavedLocations getSavedLocations,
    required SaveLocation saveLocation,
    required DeleteSavedLocation deleteSavedLocation,
    required ModalStore modalStore,
  })  : _getSavedLocations = getSavedLocations,
        _saveLocation = saveLocation,
        _deleteSavedLocation = deleteSavedLocation,
        _modalStore = modalStore;

  GetSavedLocations _getSavedLocations;
  SaveLocation _saveLocation;
  DeleteSavedLocation _deleteSavedLocation;
  ModalStore _modalStore;

  List<Location> savedLocations = List.empty(growable: true);
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool isLocationSaved(Location? location) {
    if (location == null) {
      return false;
    }

    for (Location savedLocation in savedLocations) {
      if (savedLocation.address1 == location.address1 &&
          savedLocation.address2 == location.address2) {
        return true;
      }
    }

    return false;
  }

  Future<void> getSavedLocations(User user) async {
    isLoading = true;

    try {
      final fetched = await _getSavedLocations(user);
      savedLocations
        ..clear()
        ..addAll(fetched);
      notifyListeners();
    } on AppException catch (e) {
      _modalStore.openModalForWarning(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> saveLocation(Location location, User user) async {
    isLoading = true;

    try {
      final fetched = await _saveLocation(location, user);
      savedLocations.add(fetched);
      notifyListeners();
    } on AppException catch (e) {
      _modalStore.openModalForWarning(e);
    } finally {
      isLoading = false;
      print("LOCATIONS: ${savedLocations.map((sl) => sl.address1).toList()}");
    }
  }

  Future<void> unsaveLocation(Location location) async {
    isLoading = true;

    try {
      final savedLocation = savedLocations.firstWhere((sl) =>
          sl.address1 == location.address1 && sl.address2 == location.address2);

      await _deleteSavedLocation(savedLocation);

      savedLocations.removeWhere((sl) =>
          sl.address1 == location.address1 && sl.address2 == location.address2);
      notifyListeners();
    } on AppException catch (e) {
      _modalStore.openModalForWarning(e);
    } finally {
      isLoading = false;
      print("LOCATIONS: ${savedLocations.map((sl) => sl.address1).toList()}");
    }
  }
}
