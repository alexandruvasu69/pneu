import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pneu/features/map/adapters/mapbox_controller.dart';
import 'package:pneu/features/map/domain/abstract_map_controller.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/usecases/get_location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

class MapStore extends ChangeNotifier {
  MapStore({required this.getLocation, AbstractMapController? mapController});

  CustomLatLng? _currentPosition;
  CustomLatLng? _currentCameraPosition;

  List<CustomLatLng>? route;

  GetLocation getLocation;
  Location? _selectedLocation;
  bool _isLocationLoading = false;
  String? _locationError;
  CustomScreenPosition? _locationPopupScreenCoordinate;
  CustomLatLng? _locationPopupRealCoordinate;
  bool _isLocationPopupActive = false;

  Location? get currentLocation => _selectedLocation;
  bool get isLocationLoading => _isLocationLoading;
  String? get locationError => _locationError;

  Future<void> loadLocation() async {
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      if (_locationPopupRealCoordinate != null) {
        _selectedLocation = await getLocation(
            _locationPopupRealCoordinate!.latitude,
            _locationPopupRealCoordinate!.longitude);
      }
    } catch (e) {
      _locationError = e.toString();
    }

    _isLocationLoading = false;
    notifyListeners();
  }

  CustomLatLng? get currentPosition {
    return _currentPosition;
  }

  CustomLatLng? get currentCameraPostion {
    return _currentCameraPosition;
  }

  CustomLatLng? get locationPopupRealCoordinate {
    return _locationPopupRealCoordinate;
  }

  CustomScreenPosition? get locationPopupScreenCoordinate {
    return _locationPopupScreenCoordinate;
  }

  bool get isLocationPopupActive {
    return _isLocationPopupActive;
  }

  void updateCurrentPosition(CustomLatLng currentPosition) {
    _currentPosition = currentPosition;
    print(currentPosition);
    notifyListeners();
  }

  void updateCurrentCameraPostition(CustomLatLng currentCameraPosition) {
    _currentCameraPosition = currentCameraPosition;
    notifyListeners();
  }

  void updateLocationPopupScreenCoordinate(
      CustomScreenPosition screenCoordinate) {
    _locationPopupScreenCoordinate = screenCoordinate;
    notifyListeners();
  }

  void updateIsLocationPopupActive(bool isLocationPopupActive) {
    _isLocationPopupActive = isLocationPopupActive;
    notifyListeners();
  }

  void updateLocationPopupRealCoordinate(CustomLatLng realCoord) {
    _locationPopupRealCoordinate = realCoord;
    notifyListeners();
  }

  AbstractMapController? mapController;

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

    _isLocationPopupActive = false;
    _locationPopupRealCoordinate = realCoords;
    _locationPopupScreenCoordinate = screenPosition;
    _isLocationPopupActive = true;

    notifyListeners();
  }

  void updatePopUpScreenLocation() async {
    try {
      CustomLatLng realCoord = locationPopupRealCoordinate!;

      CustomScreenPosition screenCoordinate =
          await mapController!.getScreenPositionForCoord(realCoord);

      _locationPopupScreenCoordinate = screenCoordinate;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchAndDrawRoute(CustomLatLng start) async {
    // 1) Read start/end from the store
    final CustomLatLng? end = locationPopupRealCoordinate;

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

    route = coords;

    if (coords.isEmpty) return;

    await mapController?.animateCameraToBound(coords);
    await mapController?.drawRoute(coords);

    updateIsLocationPopupActive(false);

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
