import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';

class GetEventsForBounds {
  GetEventsForBounds(this.repository);
  EventsRepository repository;

  Future<List<Event>> call(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng) async {
    final either =
        await repository.getEventsForBounds(sw_lat, sw_lng, ne_lat, ne_lng);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
