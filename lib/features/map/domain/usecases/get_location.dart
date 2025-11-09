import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';

class GetLocation {
  GetLocation(this.repository);

  LocationRepository repository;

  Future<Location> call(double lat, double lng) =>
      repository.getLocation(lat, lng);
}
