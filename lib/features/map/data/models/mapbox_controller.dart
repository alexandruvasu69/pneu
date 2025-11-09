// ignore_for_file: prefer_single_quotes

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapboxController implements AbstractMapController {
  MapboxController(this._map);
  final MapboxMap _map;
  late final PointAnnotationManager _eventAnnotationManager;
  late final CircleAnnotationManager _circleManager;

  final _sourceId = "route-source";

  @override
  Future<void> animateCamera(CustomLatLng position, double zoom) async {
    await _map.flyTo(
      CameraOptions(
        center: Point(
          coordinates: position.toMapboxPosition(),
        ),
        zoom: zoom,
        bearing: 0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }

  Future<void> showPopUp(CustomLatLng coords) async {
    PointAnnotationManager annotationManager =
        await _map.annotations.createPointAnnotationManager();

    final ByteData bytes = await rootBundle.load('assets/icons/Attention.svg');
    final Uint8List imageData = bytes.buffer.asUint8List();

    PointAnnotationOptions annotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: coords.toMapboxPosition()),
        image: imageData);

    await annotationManager.create(annotationOptions);
  }

  @override
  Future<void> drawRoute(Route route) async {
    final StyleManager style = _map.style;
    final routeId = route.routeId;

    final sourceId = '$_sourceId-$routeId';
    final streetLayerId = 'street-$routeId';
    final pedLayerId = 'ped-$routeId';

    final features = route.routeSegments.map((seg) {
      return {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates":
              seg.coordinates.map((c) => [c.longitude, c.latitude]).toList(),
        },
        "properties": {
          "mode": seg.mode,
          "highway": seg.highway,
        }
      };
    }).toList();

    final featureCollection = {
      "type": "FeatureCollection",
      "features": features,
    };

    await style.addSource(
      GeoJsonSource(
        id: sourceId,
        data: jsonEncode(featureCollection),
      ),
    );

    await style.addLayer(
      LineLayer(
        id: streetLayerId,
        sourceId: sourceId,
        filter: [
          "==",
          ["get", "mode"],
          "street",
        ],
        lineWidthExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          12,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            8,
            'primary',
            8,
            'secondary',
            8,
            'tertiary',
            8,
            'residential',
            8,
            8
          ],
          14,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            8,
            'primary',
            8,
            'secondary',
            8,
            'tertiary',
            8,
            'residential',
            8,
            8
          ],
          16,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            8,
            'primary',
            8,
            'secondary',
            8,
            'tertiary',
            8,
            'residential',
            8,
            8
          ],
          18,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            1,
            'primary',
            28,
            'secondary',
            28,
            'tertiary',
            28,
            'residential',
            21,
            8
          ],
          20,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            1,
            'primary',
            110,
            'secondary',
            98,
            'tertiary',
            104,
            'residential',
            78,
            8
          ],
          22,
          [
            'match',
            ['get', 'highway'],
            'motorway',
            1,
            'primary',
            280,
            'secondary',
            266,
            'tertiary',
            266,
            'residential',
            200,
            8
          ],
        ],
        lineColor: 0xFF007AFF,
        lineCap: LineCap.ROUND,
        lineOpacity: 0.8,
        lineOcclusionOpacity: 0,
        lineJoin: LineJoin.ROUND,
        lineElevationReference: LineElevationReference.GROUND,
      ),
    );

    await style.addLayer(
      LineLayer(
        id: pedLayerId,
        sourceId: sourceId,
        filter: [
          "==",
          ["get", "mode"],
          "pedestrian",
        ],
        lineColor: 0xFF007AFF,
        lineWidth: 5.0,
        lineOpacity: 0.8,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineDasharray: [1.0, 2.0],
      ),
    );
  }

  @override
  Future<void> animateCameraToBound(List<CustomLatLng> points) async {
    double minLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLat = points.last.latitude;
    double maxLng = points.last.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final southWest = Position(minLng, minLat);
    final northEast = Position(maxLng, maxLat);

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: southWest),
      northeast: Point(coordinates: northEast),
      infiniteBounds: false,
    );

    final cameraOptions = await _map.cameraForCoordinateBounds(
        bounds,
        MbxEdgeInsets(
          top: 100,
          left: 50,
          bottom: BarDimensions.closedPanelHeight + 250,
          right: 50,
        ),
        null,
        null,
        null,
        null);

    _map.flyTo(
      cameraOptions,
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }

  @override
  Future<void> clearRoute(Route route) async {
    final StyleManager style = _map.style;

    await style.removeStyleLayer('street-${route.routeId}');
    await style.removeStyleLayer('ped-${route.routeId}');
  }

  @override
  Future<void> init() async {
    await _map.scaleBar.updateSettings(
      ScaleBarSettings(
        enabled: false,
      ),
    );
    await _map.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    ));
    _circleManager = await _map.annotations
        .createCircleAnnotationManager(below: 'image-layer');
    await _initEventAnnotations();
  }

  Future<void> _initEventAnnotations() async {
    _eventAnnotationManager =
        await _map.annotations.createPointAnnotationManager(id: 'image-layer');
  }

  @override
  Future<CustomScreenPosition> getScreenPositionForCoord(
      CustomLatLng coord) async {
    ScreenCoordinate mapboxScreenCoordinate = await _map.pixelForCoordinate(
        Point(coordinates: Position(coord.longitude, coord.latitude)));

    return mapboxScreenCoordinate.toCustomScreenPosition();
  }

  double _calculateBearing(CustomLatLng a, CustomLatLng b) {
    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    var bearing = atan2(y, x) * 180 / pi;
    return (bearing + 360) % 360;
  }

  @override
  Future<void> animateCameraAlongRoute(
      Route route, CustomLatLng position, int sequence, double zoom) async {
    await _map.easeTo(
      CameraOptions(
          center: Point(
            coordinates: position.toMapboxPosition(),
          ),
          zoom: zoom,
          bearing: geo.Geolocator.bearingBetween(
              position.latitude,
              position.longitude,
              route
                  .routeSegments[sequence]
                  .coordinates[
                      route.routeSegments[sequence].coordinates.length - 1]
                  .latitude,
              route
                  .routeSegments[sequence]
                  .coordinates[
                      route.routeSegments[sequence].coordinates.length - 1]
                  .longitude),
          pitch: 60,
          padding: MbxEdgeInsets(top: 0, left: 0, bottom: -350, right: 0)),
      MapAnimationOptions(duration: 100, startDelay: 0),
    );
  }

  @override
  Future<void> clearMultipleRoutes(List<Route> routes) async {
    final StyleManager style = _map.style;

    for (Route route in routes) {
      final streetLayerId = 'street-${route.routeId}';
      final pedLayerId = 'ped-${route.routeId}';
      final sourceId = '$_sourceId-${route.routeId}';
      if (await style.styleLayerExists(streetLayerId)) {
        await style.removeStyleLayer(streetLayerId);
      }

      if (await style.styleLayerExists(pedLayerId)) {
        await style.removeStyleLayer(pedLayerId);
      }

      if (await style.styleSourceExists(sourceId)) {
        await style.removeStyleSource(sourceId);
      }
    }
  }

  @override
  Future<void> animateCameraBearing(
      CustomLatLng position, double bearing, double zoom) async {
    await _map.easeTo(
      CameraOptions(
          center: Point(
            coordinates: position.toMapboxPosition(),
          ),
          zoom: zoom,
          bearing: bearing,
          pitch: 60,
          padding: MbxEdgeInsets(top: 0, left: 0, bottom: -350, right: 0)),
      MapAnimationOptions(duration: 0, startDelay: 0),
    );
  }

  @override
  Future<List<CustomLatLng>> getCoordinateBoundsForCamera(
      MapCameraOptions cameraOptions) async {
    final mbxCameraOptions = _convertToMbxCameraOptions(cameraOptions);
    final bounds = await _map.coordinateBoundsForCamera(mbxCameraOptions);
    final ne = bounds.northeast.coordinates;
    final sw = bounds.southwest.coordinates;

    return <CustomLatLng>[sw.toCustomLatLng(), ne.toCustomLatLng()];
  }

  CameraOptions _convertToMbxCameraOptions(MapCameraOptions cameraOptions) {
    return CameraOptions(
      center: cameraOptions.center != null
          ? Point(coordinates: cameraOptions.center!.toMapboxPosition())
          : null,
      bearing: cameraOptions.bearing,
      pitch: cameraOptions.pitch,
      padding: cameraOptions.padding != null
          ? MbxEdgeInsets(
              top: cameraOptions.padding!.top,
              left: cameraOptions.padding!.left,
              bottom: cameraOptions.padding!.bottom,
              right: cameraOptions.padding!.right,
            )
          : null,
      anchor: cameraOptions.anchor?.toMapboxScreenCoordinate(),
    );
  }

  final Map<int, CircleAnnotation> _circleAnnotations = {};
  final Map<int, PointAnnotation> _pointAnnotations = {};

  @override
  Future<void> showEventsOnMap(List<Event> events, double zoom) async {
    final newIds = events.map((e) => e.id).toSet();
    final oldIds = _circleAnnotations.keys.toSet();

    for (final id in oldIds.difference(newIds)) {
      await _circleManager.delete(_circleAnnotations[id]!);
      await _eventAnnotationManager.delete(_pointAnnotations[id]!);
      _circleAnnotations.remove(id);
      _pointAnnotations.remove(id);
    }

    final newRadius = zoom > 14 ? 16.0 : 5.0;
    final newIconSize = zoom > 14 ? 1.0 : 0.0;

    for (final id in _circleAnnotations.keys) {
      final circle = _circleAnnotations[id]!;
      final point = _pointAnnotations[id]!;

      circle.circleRadius = newRadius;
      await _circleManager.update(circle);

      point.iconSize = newIconSize;
      await _eventAnnotationManager.update(point);
    }

    final icons = await _loadIconCache();

    for (final e in events.where((e) => !oldIds.contains(e.id))) {
      final circle = await _circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: e.geometry.toMapboxPosition()),
          circleRadius: zoom > 14 ? 16.0 : 5.0,
          circleColor: 0xFFFFFFFF,
          circleOpacity: 0.8,
          circleStrokeWidth: 2.0,
          circleStrokeColor: 0xFF8A59DE,
        ),
      );
      _circleAnnotations[e.id] = circle;

      final iconData = icons[e.subtypeId] ?? icons[-1]!;
      final point = await _eventAnnotationManager.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: e.geometry.toMapboxPosition()),
          image: iconData,
          iconSize: zoom > 14 ? 1 : 0,
        ),
      );
      _pointAnnotations[e.id] = point;
    }
  }

  Future<Map<int, Uint8List>> _loadIconCache() async {
    return {
      1: (await rootBundle.load('assets/icons/AttentionTriangle.png'))
          .buffer
          .asUint8List(),
      6: (await rootBundle.load('assets/icons/NoAccess.png'))
          .buffer
          .asUint8List(),
      3: (await rootBundle.load('assets/icons/ParkedVehicle.png'))
          .buffer
          .asUint8List(),
      -1: (await rootBundle.load('assets/icons/AttentionTriangle.png'))
          .buffer
          .asUint8List(),
    };
  }

  Future<List<CircleAnnotationOptions>> createCircleOptions(
      List<Event> events) async {
    return events.map((e) {
      return CircleAnnotationOptions(
        geometry: Point(coordinates: e.geometry.toMapboxPosition()),
        circleRadius: 16.0,
        circleColor: 0xFFFFFFFF,
        circleOpacity: 0.9,
        circleStrokeWidth: 2.0,
        circleStrokeColor: 0xFF007AFF,
      );
    }).toList();
  }
}
