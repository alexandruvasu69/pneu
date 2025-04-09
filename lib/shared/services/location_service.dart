import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled() == false) {
      throw Exception('Location Service not enabled!');
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    return Geolocator.getCurrentPosition();
  }
}
