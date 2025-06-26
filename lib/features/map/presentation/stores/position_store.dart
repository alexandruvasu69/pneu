import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class PositionStore extends ChangeNotifier {
  PositionStore({required MapStore mapStore}) : _mapStore = mapStore;

  MapStore _mapStore;

  CustomLatLng? _currentPosition;
  StreamSubscription<Position>? _positionSub;
  CustomLatLng? get currentPosition => _currentPosition;
  set currentPosition(CustomLatLng? position) {
    _currentPosition = position;
    notifyListeners();
  }

  Future<void> initializeCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled() == false) {
      throw Exception('Location Service not enabled!');
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    final Position? currentPosition = await Geolocator.getCurrentPosition();
    if (currentPosition != null) {
      _currentPosition = currentPosition.toCustomLatLng();
      notifyListeners();
    } else {
      throw Exception("Couldn't retrieve current location");
    }
  }

  void startPositionStream() {
    Geolocator.requestPermission().then((_) {
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
        ),
      ).listen((Position pos) {
        currentPosition = CustomLatLng(pos.latitude, pos.longitude);
        _mapStore.centerMapOnCurrentLocation(currentPosition!);
        notifyListeners();
      });
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
}
