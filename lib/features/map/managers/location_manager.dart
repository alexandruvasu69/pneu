import 'package:geolocator/geolocator.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/services/location_service.dart';

class LocationManager {
  LocationManager(this._mapStore);

  final MapStore _mapStore;

  Future<void> initializeCurrentLocation() async {
    final Position? currentPosition = await LocationService.getCurrentLocation();
    if (currentPosition != null) {
      final CustomLatLng currentLocation = currentPosition.toCustomLatLng();
      _mapStore.updateCurrentPosition(currentLocation);
    } else {
      throw Exception("Couldn't retrieve current location");
    }
  }
}
