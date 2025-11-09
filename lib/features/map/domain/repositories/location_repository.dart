import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

abstract class LocationRepository {
  Future<Location> getLocation(double lat, double lng);
  Future<Either<AppException, List<Location>>> suggestLocation(
      String location, User user, CustomLatLng position);
  Future<Either<AppException, Location>> retrieveLocation(String id, User user);
}
