import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class RetrieveLocation {
  RetrieveLocation(this.repository);

  LocationRepository repository;

  Future<Location> call(String id, User user) async {
    final either = await repository.retrieveLocation(id, user);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
