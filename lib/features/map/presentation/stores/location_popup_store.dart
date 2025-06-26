import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/usecases/get_location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class LocationPopupStore extends ChangeNotifier {
  LocationPopupStore({required this.getLocation});

  final GetLocation getLocation;

  Location? _selectedLocation;
  bool _isLocationPopupLoading = true;
  String? _locationPopupError;
  CustomScreenPosition? _locationPopupScreenCoordinate;
  CustomLatLng? _locationPopupRealCoordinate;
  bool _isLocationPopupActive = false;

  Location? get currentLocation => _selectedLocation;
  bool get isLocationLoading => _isLocationPopupLoading;
  String? get locationError => _locationPopupError;
  CustomScreenPosition? get locationPopupScreenCoordinate =>
      _locationPopupScreenCoordinate;
  CustomLatLng? get locationPopupRealCoordinate => _locationPopupRealCoordinate;
  bool get isLocationPopupActive => _isLocationPopupActive;

  set locationPopupScreenCoordinate(CustomScreenPosition? screenPos) {
    _locationPopupScreenCoordinate = screenPos;
    notifyListeners();
  }

  set locationPopupRealCoordinate(CustomLatLng? realCoord) {
    _locationPopupRealCoordinate = realCoord;
    notifyListeners();
  }

  set isLocationPopupActive(bool isLocationPopupActive) {
    _isLocationPopupActive = isLocationPopupActive;
    notifyListeners();
  }

  Future<void> loadLocation() async {
    _isLocationPopupLoading = true;
    _locationPopupError = null;
    notifyListeners();

    try {
      if (locationPopupRealCoordinate != null) {
        _selectedLocation = await getLocation(
            locationPopupRealCoordinate!.latitude,
            locationPopupRealCoordinate!.longitude);
      }
    } catch (e) {
      _locationPopupError = e.toString();
    }

    _isLocationPopupLoading = false;
    notifyListeners();
  }
}
