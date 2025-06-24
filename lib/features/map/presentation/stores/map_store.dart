import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/usecases/get_location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapStore extends ChangeNotifier {
  MapStore({required this.getLocation});

  CustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;

  GetLocation getLocation;
  Location? _selectedLocation;
  bool _isLocationLoading = false;
  String? _locationError;
  CustomScreenPosition? _locationPopupScreenCoordinate;
  CustomLatLng? _locationPopupRealCoordinate;
  bool _isLocationPopupActive = false;

  Location? get currentLocation => _selectedLocation;
  bool get isLocationLoading => _isLocationLoading;
  String? get locationError => _locationError;

  Future<void> loadLocation() async {
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      if (_locationPopupRealCoordinate != null) {
        _selectedLocation = await getLocation(
            _locationPopupRealCoordinate!.latitude,
            _locationPopupRealCoordinate!.longitude);
      }
    } catch (e) {
      _locationError = e.toString();
    }

    _isLocationLoading = false;
    notifyListeners();
  }

  CustomLatLng? get currentPosition {
    return _currentPosition;
  }

  CustomLatLng? get currentCameraPostion {
    return _currentCameraPosition;
  }

  CustomLatLng? get locationPopupRealCoordinate {
    return _locationPopupRealCoordinate;
  }

  CustomScreenPosition? get locationPopupScreenCoordinate {
    return _locationPopupScreenCoordinate;
  }

  bool get isLocationPopupActive {
    return _isLocationPopupActive;
  }

  void updateCurrentPosition(CustomLatLng currentPosition) {
    _currentPosition = currentPosition;
    print(currentPosition);
    notifyListeners();
  }

  void updateCurrentCameraPostition(CustomLatLng currentCameraPosition) {
    _currentCameraPosition = currentCameraPosition;
    notifyListeners();
  }

  void updateLocationPopupScreenCoordinate(
      CustomScreenPosition screenCoordinate) {
    _locationPopupScreenCoordinate = screenCoordinate;
    notifyListeners();
  }

  void updateIsLocationPopupActive(bool isLocationPopupActive) {
    _isLocationPopupActive = isLocationPopupActive;
    notifyListeners();
  }

  void updateLocationPopupRealCoordinate(CustomLatLng realCoord) {
    _locationPopupRealCoordinate = realCoord;
    notifyListeners();
  }
}
