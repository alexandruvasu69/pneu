import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapControllerService {
  MapControllerService._internal();
  static final MapControllerService _instance = MapControllerService._internal();

  static MapControllerService get instance => _instance;

  GoogleMapController? _controller;

  void setController(GoogleMapController controller) {
    _controller = controller;
  }

  void moveCamera(LatLng position, {double zoom = 16}) {
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
  }

  void dispose() {
    _controller = null;
  }
}
