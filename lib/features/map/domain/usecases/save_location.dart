import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/saved_location_repository.dart';

class SaveLocation {
  SaveLocation(this.repository);

  SavedLocationRepository repository;

  Future<Location> call(Location location, User user) async {
    final either = await repository.saveLocation(location, user);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
