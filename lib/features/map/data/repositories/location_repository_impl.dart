import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/data/datasources/location_mapbox_geocoding_data_source.dart';
import 'package:pneu/features/map/data/models/location_model.dart';
import 'package:pneu/features/map/data/models/retrieved_location_model.dart';
import 'package:pneu/features/map/data/models/suggested_location_model.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/features/map/domain/usecases/retrieve_location.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(this.source);
  final LocationMapboxGeocodingDataSource source;

  @override
  Future<Location> getLocation(double lat, double lng) async {
    Map<String, dynamic>? data = await source.getLocationReverse(lat, lng);

    return LocationModel.fromJson(data!);
  }

  @override
  Future<Either<AppException, List<Location>>> suggestLocation(
      String location, User user, CustomLatLng position) async {
    final either = await source.suggestLocation(location, user, position);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      final model = either.right.map((json) {
        return SuggestedLocationModel.fromJson(json);
      }).toList();

      return Either.right(model);
    } catch (e) {
      return Either.left(
          ParsingException(e.toString() + " LOCATION REPOSITORY"));
    }
  }

  @override
  Future<Either<AppException, Location>> retrieveLocation(
      String id, User user) async {
    final either = await source.retrieveLocation(id, user);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      final model = RetrievedLocationModel.fromJson(either.right);

      return Either.right(model);
    } catch (e) {
      return Either.left(
          ParsingException(e.toString() + " LOCATION REPOSITORY"));
    }
  }
}
