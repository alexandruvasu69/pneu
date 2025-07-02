// ignore_for_file: prefer_single_quotes

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapboxController implements AbstractMapController {
  MapboxController(this._map);
  final MapboxMap _map;

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

    // if (await style.styleLayerExists(streetLayerId)) {
    //   await style.removeStyleLayer(streetLayerId);
    // }
    // if (await style.styleLayerExists(pedLayerId)) {
    //   await style.removeStyleLayer(pedLayerId);
    // }
    // if (await style.styleSourceExists(sourceId)) {
    //   await style.removeStyleSource(sourceId);
    // }

    final features = route.routeSegments.map((seg) {
      return {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates":
              seg.coordinates.map((c) => [c.longitude, c.latitude]).toList(),
        },
        "properties": {
          "mode": seg.mode, // e.g. "street" or "pedestrian"
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
        // no dasharray → solid
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
        lineCap: LineCap.ROUND, // capetele liniei rotunjite
        lineJoin: LineJoin.ROUND,
        lineDasharray: [1.0, 2.0], // [length of dash, length of gap]
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
          bottom: BarDimensions.closedPanelHeight + 220,
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
    // normalizează în 0–360
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
}
