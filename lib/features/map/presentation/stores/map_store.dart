import 'package:flutter/material.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapStore extends ChangeNotifier {
  CustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;

  CustomScreenPosition? _locationPopupScreenCoordinate;
  CustomLatLng? _locationPopupRealCoordinate;
  bool _isLocationPopupActive = false;

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

  void updateLocationPopupScreenCoordinate(CustomScreenPosition screenCoordinate) {
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
