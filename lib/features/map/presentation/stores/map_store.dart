import 'package:flutter/material.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class MapStore extends ChangeNotifier {
  CustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;

  CustomLatLng? get currentPosition {
    return _currentPosition;
  }

  CustomLatLng? get currentCameraPostion {
    return _currentCameraPosition;
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
}
