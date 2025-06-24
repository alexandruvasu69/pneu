import 'package:pneu/features/map/domain/entities/location.dart';

abstract class LocationRepository {
  Future<Location> getLocation(double lat, double lng);
}
