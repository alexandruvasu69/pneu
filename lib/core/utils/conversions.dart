import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:pneu/shared/models/custom_lat_lng.dart';

extension CustomLatLngToMapboxPosition on CustomLatLng {
  mb.Position toMapboxPosition() => mb.Position(longitude, latitude);
}

extension MapboxPositionToCustomLatLng on mb.Position {
  CustomLatLng toCustomLatLng() => CustomLatLng(lat.toDouble(), lng.toDouble());
}

extension GeolocationPositionToCustomLatLng on geo.Position {
  CustomLatLng toCustomLatLng() => CustomLatLng(latitude, longitude);
}
