import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';

class AddEvent {
  AddEvent(this.repository);
  EventsRepository repository;

  Future<Event> call(double lat, double lng, int category, String userId,
      String description) async {
    final either =
        await repository.addEvent(lat, lng, category, userId, description);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
