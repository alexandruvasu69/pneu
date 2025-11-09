import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/saved_location_repository.dart';

class DeleteSavedLocation {
  DeleteSavedLocation(this.repository);

  SavedLocationRepository repository;

  Future<bool> call(Location location) async {
    final either = await repository.deleteLocation(location);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
