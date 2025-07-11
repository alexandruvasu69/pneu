import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/repositories/events_repository.dart';

class ApproveEvent {
  ApproveEvent(this.repository);
  EventsRepository repository;

  Future<Event> call(Event event, User user) async {
    final either = await repository.approveEvent(event, user);

    if (either.isLeft) {
      throw either.left;
    }

    return either.right;
  }
}
