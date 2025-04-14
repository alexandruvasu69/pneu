import 'package:pneu/features/map/adapters/mapbox_controller.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class MapControllerManager {
  MapControllerManager(this._mapStore);

  final MapStore _mapStore;

  void centerMapOnCurrentLocation() {
    CustomLatLng? currentPosition = _mapStore.currentPosition;
    if (currentPosition != null) {
      MapboxController.getInstance().animateCamera(currentPosition, 16);
    } else {
      throw Exception('Current location not found');
    }
  }
}
