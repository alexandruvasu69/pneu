import 'package:pneu/features/map/data/datasources/location_mapbox_geocoding_data_source.dart';
import 'package:pneu/features/map/data/models/location_model.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(this.source);
  final LocationMapboxGeocodingDataSource source;

  @override
  Future<Location> getLocation(double lat, double lng) async {
    Map<String, dynamic>? data = await source.getLocation(lat, lng);

    return LocationModel.fromJson(data!);
  }
}
