import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

abstract class AbstractMapController {
  Future<void> init();

  Future<void> animateCamera(CustomLatLng position, double zoom);

  Future<void> animateCameraToBound(List<CustomLatLng> boundingBox);

  Future<void> drawRoute(Route route);

  Future<void> clearRoute(Route route);
  Future<void> clearMultipleRoutes(List<Route> routes);

  Future<CustomScreenPosition> getScreenPositionForCoord(CustomLatLng coord);

  Future<void> animateCameraAlongRoute(
      Route route, CustomLatLng position, int routeSequence, double zoom);

  Future<void> animateCameraBearing(
      CustomLatLng position, double bearing, double zoom);
}
