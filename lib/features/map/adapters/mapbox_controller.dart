// ignore_for_file: prefer_single_quotes

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/domain/abstract_map_controller.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class MapboxController extends AbstractMapController<MapboxMap> {
  MapboxController._internal();

  static MapboxController? _instance;

  static MapboxController getInstance() {
    _instance ??= MapboxController._internal();

    return _instance!;
  }

  @override
  Future<void> animateCamera(CustomLatLng position, double zoom) async {
    await getController()!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: position.toMapboxPosition(),
        ),
        zoom: zoom,
        bearing: 0,
      ),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
  }

  @override
  Future<void> updateSettings() async {
    await getController()!.scaleBar.updateSettings(
          ScaleBarSettings(
            enabled: false,
          ),
        );
    await getController()!.location.updateSettings(LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
        ));
  }

  Future<void> showPopUp(CustomLatLng coords) async {
    PointAnnotationManager annotationManager = await getController()!.annotations.createPointAnnotationManager();

    final ByteData bytes = await rootBundle.load('assets/icons/Attention.svg');
    final Uint8List imageData = bytes.buffer.asUint8List();

    PointAnnotationOptions annotationOptions =
        PointAnnotationOptions(geometry: Point(coordinates: coords.toMapboxPosition()), image: imageData);

    await annotationManager.create(annotationOptions);
  }

  Future<void> drawRoute(List<CustomLatLng> coords) async {
    final MapboxMap? map = getController();
    if (map == null) return;

    final StyleManager style = map.style;
    const String sourceId = 'route-source';
    const String layerId = 'route-layer';

    // 1) Șterge vechiul layer/source dacă există
    if (await style.styleLayerExists(layerId)) {
      await style.removeStyleLayer(layerId);
    }
    if (await style.styleSourceExists(sourceId)) {
      await style.removeStyleSource(sourceId);
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
            "coordinates": coords.map((c) => [c.longitude, c.latitude]).toList(),
          },
          // ignore: always_specify_types
          "properties": {}
        }
      ]
    };

    // 3) Adaugă sursa GeoJSON
    await style.addSource(
      GeoJsonSource(
        id: sourceId,
        data: jsonEncode(featureCollection),
      ),
    );

    // 4) Adaugă layer-ul de tip linie
    await style.addLayer(
      LineLayer(
        id: layerId,
        sourceId: sourceId,
        // style your line any way you like:
        lineColor: 0xFF007AFF,
        lineWidth: 4.0,
        lineOpacity: 0.8,
      ),
    );
  }
}
