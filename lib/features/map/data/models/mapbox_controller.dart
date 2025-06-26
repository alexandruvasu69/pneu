// ignore_for_file: prefer_single_quotes

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/constants/app/footer_constants.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapboxController implements AbstractMapController {
  MapboxController(this._map);
  final MapboxMap _map;

  final _sourceId = "route-source";
  final _layerId = "route-layer";

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

  Future<void> drawRoute(List<CustomLatLng> coords) async {
    final StyleManager style = _map.style;

    // 1) Șterge vechiul layer/source dacă există
    if (await style.styleLayerExists(_layerId)) {
      await style.removeStyleLayer(_layerId);
    }
    if (await style.styleSourceExists(_sourceId)) {
      await style.removeStyleSource(_sourceId);
    }

    // 2) Creează GeoJSON-ul pentru Linia de rută
    // ignore: always_specify_types
    final featureCollection = {
      "type": "FeatureCollection",
      // ignore: always_specify_types
      "features": [
        // ignore: always_specify_types
        {
          "type": "Feature",
          // ignore: always_specify_types
          "geometry": {
            "type": "LineString",
            // ignore: always_specify_types
            "coordinates":
                coords.map((c) => [c.longitude, c.latitude]).toList(),
          },
          // ignore: always_specify_types
          "properties": {}
        }
      ]
    };

    // 3) Adaugă sursa GeoJSON
    await style.addSource(
      GeoJsonSource(
        id: _sourceId,
        data: jsonEncode(featureCollection),
      ),
    );

    // 4) Adaugă layer-ul de tip linie
    await style.addLayer(
      LineLayer(
        id: _layerId,
        sourceId: _sourceId,
        // style your line any way you like:
        lineColor: 0xFF007AFF,
        lineWidth: 4.0,
        lineOpacity: 0.8,
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
  Future<void> clearRoute() async {
    final StyleManager style = _map.style;

    await style.removeStyleLayer(_layerId);
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
    return (bearing + 180) % 360;
  }

  @override
  Future<void> animateCameraAlongRoute(
      List<CustomLatLng> coords, double zoom) async {
    await _map.easeTo(
      CameraOptions(
          center: Point(
            coordinates: coords[0].toMapboxPosition(),
          ),
          zoom: zoom,
          bearing: _calculateBearing(coords[0], coords[1]),
          pitch: 60),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }
}
