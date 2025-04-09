import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapStore extends ChangeNotifier {
  LatLng? _currentPosition;
  LatLng? _currentCameraPosition;

  LatLng? get currentPosition {
    return _currentPosition;
  }

  LatLng? get currentCameraPostion {
    return _currentCameraPosition;
  }

  void updateCurrentPosition(LatLng currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  void updateCurrentCameraPostition(LatLng currentCameraPosition) {
    _currentCameraPosition = currentCameraPosition;
    notifyListeners();
  }
}
