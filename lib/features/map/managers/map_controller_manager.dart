import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/features/map/services/map_controller_service.dart';

class MapControllerManager {
  MapControllerManager(this._mapStore);

  final MapStore _mapStore;

  void centerMapOnCurrentLocation() {
    LatLng? currentPosition = _mapStore.currentPosition;
    if (currentPosition != null) {
      MapControllerService.instance.moveCamera(currentPosition);
    } else {
      throw Exception('Current location not found');
    }
  }
}
