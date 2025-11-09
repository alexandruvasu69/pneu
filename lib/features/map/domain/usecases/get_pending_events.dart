import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';

class GetPendingEvents {
  GetPendingEvents(this.repository);

  EventsRepository repository;

  Future<List<Event>> call() async {
    final either = await repository.getPendingEvents();

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
