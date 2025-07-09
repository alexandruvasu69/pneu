import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/data/models/mapbox_controller.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/entities/route_segment.dart';
import 'package:pneu/features/map/presentation/stores/events_store.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/features/map/presentation/stores/position_store.dart';
import 'package:pneu/features/map/presentation/stores/route_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';
import 'package:pneu/features/map/domain/entities/route.dart' as r;

class MapStore extends ChangeNotifier {
  MapStore(
      {required LocationPopupStore locationPopupStore,
      required RouteStore routeStore,
      required PositionStore positionStore})
      : _locationPopupStore = locationPopupStore,
        _routeStore = routeStore,
        _positionStore = positionStore;

  LocationPopupStore _locationPopupStore;
  RouteStore _routeStore;
  PositionStore _positionStore;

  AbstractMapController? mapController;

//   CustomCustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;
//   CustomLatLng? get currentPosition => _currentPosition;
  CustomLatLng? get currentCameraPostion => _currentCameraPosition;

  List<CustomLatLng>? route;

  bool isCentering = false;
  bool isNavigatingRoute = false;
  double _zoom = 16;

  double get zoom => _zoom;
  set zoom(double zoom) {
    _zoom = zoom;
    notifyListeners();
  }

//   void updateCurrentPosition(CustomLatLng currentPosition) {
//     _currentPosition = currentPosition;
//     print(currentPosition);
//     notifyListeners();
//   }

  void updateCurrentCameraPostition(CustomLatLng currentCameraPosition) {
    _currentCameraPosition = currentCameraPosition;
    notifyListeners();
  }

  void centerMapOnCurrentLocation(CustomLatLng currentPosition) {
    mapController?.animateCamera(currentPosition, 16);
    isCentering = true;

    notifyListeners();
  }

  void centerMapOnLocationPopup(
      {required CustomLatLng realCoords,
      CustomScreenPosition? screenPosition}) async {
    await mapController?.animateCamera(realCoords, 16);

    _locationPopupStore.isLocationPopupLoading = true;
    _locationPopupStore.isLocationPopupActive = false;
    _locationPopupStore.locationPopupRealCoordinate = realCoords;
    if (screenPosition != null)
      _locationPopupStore.locationPopupScreenCoordinate = screenPosition;
    _locationPopupStore.isLocationPopupActive = true;

    notifyListeners();
  }

  void updatePopUpScreenLocation() async {
    try {
      CustomLatLng realCoord = _locationPopupStore.locationPopupRealCoordinate!;

      CustomScreenPosition screenCoordinate =
          await mapController!.getScreenPositionForCoord(realCoord);

      _locationPopupStore.locationPopupScreenCoordinate = screenCoordinate;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> drawRoutes(List<r.Route> routes) async {
    await mapController?.drawRoute(routes[0]);
    final coords = routes[0]
        .routeSegments
        .expand((seg) =>
            seg.coordinates.map((c) => CustomLatLng(c.latitude, c.longitude)))
        .toList();
    await mapController?.animateCameraToBound(coords);
    // await mapController?.drawRoute(coords);
    _locationPopupStore.isLocationPopupActive = false;

    notifyListeners();
  }

  Future<void> clearAllRoutes() async {
    await mapController?.clearMultipleRoutes(_routeStore.routeOptions!);
    notifyListeners();
  }

  Future<void> initController(MapboxController controller) async {
    mapController = controller;
    await mapController?.init();

    notifyListeners();
  }

  Future<void> startRoute() async {
    isNavigatingRoute = true;
    isCentering = true;
    isAutoCentering = true;

    final List<RouteSegment> route_segments =
        _routeStore.selectedRoute!.routeSegments;
    for (RouteSegment r in route_segments) {
      print(r.coordinates);
    }

    mapController?.animateCameraAlongRoute(_routeStore.selectedRoute!,
        _positionStore.currentPosition!, _routeSequence, 18);

    _positionStore.addListener(_onPositionUpdate);

    notifyListeners();
  }

  Future<void> cancelRoute() async {
    isNavigatingRoute = false;
    isCentering = false;
    isAutoCentering = false;

    await clearAllRoutes();

    _positionStore.removeListener(_onPositionUpdate);

    _routeStore.selectedRoute = null;
    _routeStore.routeOptions?.clear();

    mapController?.animateCamera(_positionStore.currentPosition!, 16);

    notifyListeners();
  }

  int _routeSequence = 1;
  bool _isAutoCentering = false;

  bool get isAutoCentering => _isAutoCentering;
  set isAutoCentering(bool isCentering) {
    _isAutoCentering = isCentering;
    notifyListeners();
  }

  void _onPositionUpdate() async {
    final pos = _positionStore.currentPosition;
    final route = _routeStore.selectedRoute;
    // double? bearing;
    print(
        "COORD FOR BEARING ${route?.routeSegments[_routeSequence].coordinates[route.routeSegments[_routeSequence].coordinates.length - 1]}");
    print('SEQUENCE: ${_routeSequence}');
    print("LENGTH: ${route?.routeSegments.length}");

    if (!isNavigatingRoute ||
        pos == null ||
        route == null ||
        _positionStore.bearing == null) return;
    // _routeSequence = _calculateSequence(pos, route, _routeSequence);
    if (isNavigatingRoute && isAutoCentering) {
      //   await mapController!
      //       .animateCameraAlongRoute(route, pos, _routeSequence, 18);
      await mapController!
          .animateCameraBearing(pos, _positionStore.bearing!, 18);
    }
  }

  int _calculateSequence(
      CustomLatLng position, r.Route route, int currentSequence) {
    final segCoords = route.routeSegments[currentSequence].coordinates;

    final d = distancePointToLine(position, segCoords);

    if (d < 15) {
      return currentSequence + 1;
    } else if (d >= 100) {
      for (RouteSegment rs in route.routeSegments) {
        final d2 = distancePointToLine(position, rs.coordinates);

        if (d2 < 15) {
          return route.routeSegments.indexOf(rs);
        }
      }
    }

    return currentSequence;
  }

  double distancePointToLine(CustomLatLng p, List<CustomLatLng> line) {
    const double R = 6371e3; // earth radius in meters

    double toRad(double deg) => deg * math.pi / 180;
    double haversineDistance(CustomLatLng a, CustomLatLng b) {
      final f1 = toRad(a.latitude);
      final f2 = toRad(b.latitude);
      final df = toRad(b.latitude - a.latitude);
      final de = toRad(b.longitude - a.longitude);
      final sindf2 = math.sin(df / 2), sinde2 = math.sin(de / 2);
      final A = sindf2 * sindf2 + math.cos(f1) * math.cos(f2) * sinde2 * sinde2;
      final C = 2 * math.atan2(math.sqrt(A), math.sqrt(1 - A));
      return R * C;
    }

    double bearing(CustomLatLng a, CustomLatLng b) {
      final f1 = toRad(a.latitude);
      final f2 = toRad(b.latitude);
      final de = toRad(b.longitude - a.longitude);
      final y = math.sin(de) * math.cos(f2);
      final x = math.cos(f1) * math.sin(f2) -
          math.sin(f1) * math.cos(f2) * math.cos(de);
      return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
    }

    // cross-track distance (signed) from p to great-circle AB
    double crossTrack(CustomLatLng p, CustomLatLng A, CustomLatLng B) {
      final ro13 = haversineDistance(A, p) / R;
      final t13 = toRad(bearing(A, p));
      final t12 = toRad(bearing(A, B));
      return math.asin(math.sin(ro13) * math.sin(t13 - t12)) * R;
    }

    // along-track distance from A to projection of p onto AB
    double alongTrack(CustomLatLng p, CustomLatLng A, CustomLatLng B) {
      final ro13 = haversineDistance(A, p) / R;
      final xt = crossTrack(p, A, B) / R;
      return math.acos(math.cos(ro13) / math.cos(xt)) * R;
    }

    if (line.length < 2) return double.infinity;
    double minDist = double.infinity;

    for (var i = 0; i < line.length - 1; i++) {
      final A = line[i], B = line[i + 1];
      final segLen = haversineDistance(A, B);
      final xt = crossTrack(p, A, B).abs();
      final at = alongTrack(p, A, B);

      double d;
      if (at >= 0 && at <= segLen) {
        // perpendicular projection falls on segment
        d = xt;
      } else {
        // use nearest endpoint
        d = math.min(haversineDistance(p, A), haversineDistance(p, B));
      }

      if (d < minDist) minDist = d;
    }

    print('DISTANCE FROM NEXT LINE: ${minDist}');

    return minDist;
  }

  Future<List<CustomLatLng>> getBounds(MapCameraOptions cameraOptions) async {
    final bounds =
        await mapController?.getCoordinateBoundsForCamera(cameraOptions);
    return bounds ?? List.empty();
  }

  Future<void> drawEvents(List<Event> events, double zoom) async {
    await mapController?.showEventsOnMap(events, zoom);
    notifyListeners();
  }
}
