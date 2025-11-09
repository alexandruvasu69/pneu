import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/saved_location_repository.dart';

class GetSavedLocations {
  GetSavedLocations(this.repository);

  SavedLocationRepository repository;

  Future<List<Location>> call(User user) async {
    final either = await repository.getLocations(user);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
