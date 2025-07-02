import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class PositionStore extends ChangeNotifier {
  PositionStore();

  CustomLatLng? _currentPosition;
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<CompassEvent>? _compassSub;
  CustomLatLng? get currentPosition => _currentPosition;
  double? _bearing;
  double _offset = 0;

  set currentPosition(CustomLatLng? position) {
    _currentPosition = position;
    notifyListeners();
  }

  double? get bearing {
    if (_bearing == null) return null;
    return (_bearing! + _offset) % 360;
  }

  set bearing(double? bearing) {
    _bearing = bearing;
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
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        ),
      ).listen((Position pos) {
        currentPosition = CustomLatLng(pos.latitude, pos.longitude);
      });
    });

    FlutterCompass.events!.listen((CompassEvent event) {
      bearing = event.heading;
      print("NORTH BEARING: ${bearing}");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _compassSub?.cancel();
    super.dispose();
  }
}
