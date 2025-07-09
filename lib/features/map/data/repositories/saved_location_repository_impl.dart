import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/data/datasources/location_mapbox_geocoding_data_source.dart';
import 'package:pneu/features/map/data/datasources/saved_locations_supabase_datasource.dart';
import 'package:pneu/features/map/data/models/location_model.dart';
import 'package:pneu/features/map/data/models/saved_location_model.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/features/map/domain/repositories/saved_location_repository.dart';

class SavedLocationRepositoryImpl implements SavedLocationRepository {
  SavedLocationRepositoryImpl(this.source);

  final SavedLocationsSupabaseDatasource source;

  @override
  Future<Either<AppException, List<Location>>> getLocations(User user) async {
    final either = await source.getSavedLocations(user);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      List<Location> savedLocations = either.right
          .map((jsonObj) => SavedLocationModel.fromJson(jsonObj))
          .toList();
      return Either.right(savedLocations);
    } catch (e) {
      return Either.left(
          ParsingException(e.toString() + " SAVED LOCATIONS REPOSITORY 1"));
    }
  }

  @override
  Future<Either<AppException, bool>> deleteLocation(Location location) async {
    final either = await source.deleteSavedLocation(location);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      return Either.right(either.right);
    } catch (e) {
      return Either.left(
          ParsingException(e.toString() + " SAVED LOCATIONS REPOSITORY 2"));
    }
  }

  @override
  Future<Either<AppException, Location>> saveLocation(
      Location location, User user) async {
    final either = await source.saveLocation(location, user);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      Location location = SavedLocationModel.fromJson(either.right);
      return Either.right(location);
    } catch (e) {
      return Either.left(ParsingException(e.toString()));
    }
  }
}
