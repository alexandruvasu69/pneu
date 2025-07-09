import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/map/data/datasources/events_supabase_datasource.dart';
import 'package:pneu/features/map/data/models/event_model.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  EventsRepositoryImpl(this.source);
  EventsSupabaseDatasource source;

  @override
  Future<Either<AppException, List<Event>>> getEventsForBounds(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng) async {
    final either =
        await source.getEventsForBounds(sw_lat, sw_lng, ne_lat, ne_lng);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      print(either.right);
      List<Event> events =
          either.right.map((e) => EventModel.fromJson(e)).toList();
      return Either.right(events);
    } catch (e) {
      return Either.left(ParsingException(e.toString() + " EVENTS REPOSITORY"));
    }
  }

  @override
  Future<Either<AppException, Event>> addEvent(double lat, double lng,
      int category, String userId, String description) async {
    final either =
        await source.addEvent(lat, lng, category, userId, description);

    if (either.isLeft) {
      return Either.left(either.left);
    }

    try {
      final event = EventModel.fromJson(either.right);
      return Either.right(event);
    } catch (e) {
      return Either.left(ParsingException(e.toString() + " EVENTS REPOSITORY"));
    }
  }
}
