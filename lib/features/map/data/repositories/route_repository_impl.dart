import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/data/datasources/routes_supabase_datasource.dart';
import 'package:pneu/features/map/data/models/route_model.dart';
import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/features/map/domain/repositories/route_repository.dart';

class RouteRepositoryImpl implements RouteRepository {
  RouteRepositoryImpl(this.source);
  final RoutesSupabaseDatasource source;

  @override
  Future<Either<AppException, List<Route>>> getCalculatedRoutes(
      double startLat, double startLng, double endLat, double endLng) async {
    final either = await source.getRoutes(startLat, startLng, endLat, endLng);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      final model =
          either.right.map((json) => RouteModel.fromJson(json)).toList();
      return Either.right(model);
    } catch (e) {
      return Either.left(ParsingException(e.toString() + " ROUTE REPOSITORY"));
    }
  }
}
