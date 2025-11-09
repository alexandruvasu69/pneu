import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/route.dart';

abstract class RouteRepository {
  Future<Either<AppException, List<Route>>> getCalculatedRoutes(
      double startLat, double startLng, double endLat, double endLng);
}
