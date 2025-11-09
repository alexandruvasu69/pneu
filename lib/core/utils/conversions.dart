import 'package:geodesy/geodesy.dart' as geodesy;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:pneu/shared/models/custom_lat_lng.dart';
import 'package:pneu/shared/models/custom_screen_position.dart';

extension CustomLatLngToMapboxPosition on CustomLatLng {
  mb.Position toMapboxPosition() => mb.Position(longitude, latitude);
}

extension MapboxPositionToCustomLatLng on mb.Position {
  CustomLatLng toCustomLatLng() => CustomLatLng(lat.toDouble(), lng.toDouble());
}

extension GeolocationPositionToCustomLatLng on geo.Position {
  CustomLatLng toCustomLatLng() => CustomLatLng(latitude, longitude);
}

extension CustomLatLngToGeodesy on CustomLatLng {
  geodesy.LatLng toGeodesyLatLng() => geodesy.LatLng(latitude, longitude);
}

extension ScreenCoordinatesToCustomScreenPosition on mb.ScreenCoordinate {
  CustomScreenPosition toCustomScreenPosition() => CustomScreenPosition(x, y);
}

extension CustomScreenPositionToScreenCoordinates on CustomScreenPosition {
  mb.ScreenCoordinate toMapboxScreenCoordinate() =>
      mb.ScreenCoordinate(x: x, y: y);
}
