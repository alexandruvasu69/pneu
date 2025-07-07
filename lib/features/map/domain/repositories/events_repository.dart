import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/domain/entities/event.dart';

abstract class EventsRepository {
  Future<Either<AppException, List<Event>>> getEventsForBounds(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng);

  Future<Either<AppException, Event>> addEvent(
      double lat, double lng, int category, String userId, String description);
}
