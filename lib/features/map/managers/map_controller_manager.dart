import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pneu/core/utils/conversions.dart';
import 'package:pneu/features/map/adapters/mapbox_controller.dart';
import 'package:pneu/features/map/presentation/stores/map_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';
import 'package:http/http.dart' as http;

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

  void centerMapOnLocationPopup(
      CustomLatLng realCoords, CustomScreenPosition screenPosition) async {
    await MapboxController.getInstance().animateCamera(realCoords, 16);

    _mapStore.updateIsLocationPopupActive(false);
    _mapStore.updateLocationPopupRealCoordinate(realCoords);
    _mapStore.updateLocationPopupScreenCoordinate(screenPosition);
    _mapStore.updateIsLocationPopupActive(true);
  }

  void updatePopUpScreenLocation() async {
    CustomLatLng realCoord = _mapStore.locationPopupRealCoordinate!;

    CustomScreenPosition screenCoordinate =
        (await MapboxController.getInstance()
                .getController()!
                .pixelForCoordinate(
                    Point(coordinates: realCoord.toMapboxPosition())))
            .toCustomScreenPosition();

    _mapStore.updateLocationPopupScreenCoordinate(screenCoordinate);
  }

  Future<void> fetchAndDrawRoute() async {
    // 1) Read start/end from the store
    final CustomLatLng? start = _mapStore.currentPosition;
    final CustomLatLng? end = _mapStore.locationPopupRealCoordinate;

    if (start == null || end == null) {
      throw Exception('Start or end location not set');
    }

    // 2) Build URL and call your route API
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/get_full_route_with_events_manual');
    final http.Response resp = await http.post(
      url,
      // ignore: always_specify_types
      headers: {
        'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
        'Content-Type': 'application/json',
      },
      // ignore: always_specify_types
      body: jsonEncode({
        'start_lon': start.longitude,
        'start_lat': start.latitude,
        'end_lon': end.longitude,
        'end_lat': end.latitude,
      }),
    );

    print('RESPONSE: ${resp.statusCode} ${resp.body}');
    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body);
      // data is a List of rows with seq, geom, cost, lts, mode, events
      print('RESPONSE: $data');
    } else {
      throw Exception('RPC error: ${resp.statusCode} ${resp.body}');
    }

    // 3) Parse JSON into List<CustomLatLng>
    final List<dynamic> data = json.decode(resp.body) as List<dynamic>;
    final List<CustomLatLng> coords =
        data.expand<CustomLatLng>((dynamic segment) {
      final Map<String, dynamic> geom = segment['geom'] as Map<String, dynamic>;
      final List<dynamic> pts = geom['coordinates'] as List<dynamic>;
      return pts.map<CustomLatLng>((dynamic pt) {
        return CustomLatLng(
          (pt[1] as num).toDouble(),
          (pt[0] as num).toDouble(),
        );
      });
    }).toList();

    if (coords.isEmpty) return;

    // 3) draw route
    final MapboxController mapCtrl = MapboxController.getInstance();
    await mapCtrl.animateCameraToBound(coords);
    await mapCtrl.drawRoute(coords);

    _mapStore.updateIsLocationPopupActive(false);
  }
}
