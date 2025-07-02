import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/features/map/domain/repositories/route_repository.dart';

class GetCalculatedRoutes {
  GetCalculatedRoutes(this.repository);

  RouteRepository repository;

  Future<List<Route>> call(
      double startLat, double startLng, double endLat, double endLng) async {
    final either = await repository.getCalculatedRoutes(
        startLat, startLng, endLat, endLng);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
