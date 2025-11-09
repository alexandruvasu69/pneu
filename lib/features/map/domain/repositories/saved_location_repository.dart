import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';

abstract class SavedLocationRepository {
  Future<Either<AppException, List<Location>>> getLocations(User user);
  Future<Either<AppException, Location>> saveLocation(
      Location location, User user);
  Future<Either<AppException, bool>> deleteLocation(Location location);
}
