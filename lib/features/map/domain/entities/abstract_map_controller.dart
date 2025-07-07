import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
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

  Future<List<CustomLatLng>> getCoordinateBoundsForCamera(
      MapCameraOptions cameraOptions);

  Future<void> showEventsOnMap(List<Event> events, double zoom);
}

class MapCameraOptions {
  MapCameraOptions(
      {this.center,
      this.zoom,
      this.bearing,
      this.pitch,
      this.padding,
      this.anchor});

  CustomLatLng? center;
  double? zoom;
  double? bearing;
  double? pitch;
  MapEdgeInsets? padding;
  CustomScreenPosition? anchor;
}

class MapEdgeInsets {
  MapEdgeInsets(
      {required this.top,
      required this.left,
      required this.bottom,
      required this.right});

  double top;
  double left;
  double bottom;
  double right;
}
