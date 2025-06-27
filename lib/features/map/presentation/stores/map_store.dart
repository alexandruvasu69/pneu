import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pneu/features/map/data/models/mapbox_controller.dart';
import 'package:pneu/features/map/domain/entities/abstract_map_controller.dart';
import 'package:pneu/features/map/presentation/stores/location_popup_store.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapStore extends ChangeNotifier {
  MapStore({
    required LocationPopupStore locationPopupStore,
  }) : _locationPopupStore = locationPopupStore;

  LocationPopupStore _locationPopupStore;

  AbstractMapController? mapController;

//   CustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;
//   CustomLatLng? get currentPosition => _currentPosition;
  CustomLatLng? get currentCameraPostion => _currentCameraPosition;

  List<CustomLatLng>? route;

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
    // CustomLatLng? currentPosition = _currentPosition;
    // if (currentPosition != null) {
    mapController?.animateCamera(currentPosition, 16);
    // } else {
    //   throw Exception('Current location not found');
    // }

    notifyListeners();
  }

  void centerMapOnLocationPopup(
      CustomLatLng realCoords, CustomScreenPosition screenPosition) async {
    await mapController?.animateCamera(realCoords, 16);

    _locationPopupStore.isLocationPopupLoading = true;
    _locationPopupStore.isLocationPopupActive = false;
    _locationPopupStore.locationPopupRealCoordinate = realCoords;
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

  Future<void> fetchAndDrawRoute(CustomLatLng start) async {
    // 1) Read start/end from the store
    final CustomLatLng? end = _locationPopupStore.locationPopupRealCoordinate;

    if (start == null || end == null) {
      throw Exception('Start or end location not set');
    }

    // 2) Build URL and call your route API
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/get_route_with_loop_fix');
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

    route = coords;

    if (coords.isEmpty) return;

    await mapController?.animateCameraToBound(coords);
    await mapController?.drawRoute(coords);

    _locationPopupStore.isLocationPopupActive = false;

    notifyListeners();
  }

  Future<void> clearRoute() async {
    await mapController?.clearRoute();
  }

  Future<void> initController(MapboxController controller) async {
    mapController = controller;
    await mapController?.init();

    notifyListeners();
  }

  Future<void> startRoute() async {
    mapController?.animateCameraAlongRoute(route!, 18);
  }
}
