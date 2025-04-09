import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/services/location_service.dart';

class LocationManager {
  LocationManager(this._mapStore);

  final MapStore _mapStore;

  Future<void> initializeCurrentLocation() async {
    final Position? currentPosition = await LocationService.getCurrentLocation();
    if (currentPosition != null) {
      final LatLng currentLocation = _convertPositionToLatLng(currentPosition);
      _mapStore.updateCurrentPosition(currentLocation);
    } else {
      throw Exception("Couldn't retrieve current location");
    }
  }

  LatLng _convertPositionToLatLng(Position currentPosition) {
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }
}
