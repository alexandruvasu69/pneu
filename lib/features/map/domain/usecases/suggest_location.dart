import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';
import 'package:pneu/features/map/domain/repositories/location_repository.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class SuggestLocation {
  SuggestLocation(this.repository);

  LocationRepository repository;

  Future<List<Location>> call(
      String location, User user, CustomLatLng position) async {
    final either = await repository.suggestLocation(location, user, position);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
