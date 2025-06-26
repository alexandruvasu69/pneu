import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

abstract class AbstractMapController {
  Future<void> init();

  Future<void> animateCamera(CustomLatLng position, double zoom);

  Future<void> animateCameraToBound(List<CustomLatLng> boundingBox);

  Future<void> drawRoute(List<CustomLatLng> coords);

  Future<void> clearRoute();

  Future<CustomScreenPosition> getScreenPositionForCoord(CustomLatLng coord);

  Future<void> animateCameraAlongRoute(List<CustomLatLng> coords, double zoom);
}
