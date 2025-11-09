import 'package:flutter/material.dart' as m;
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/usecases/add_event.dart';
import 'package:pneu/features/map/domain/usecases/approve_event.dart';
import 'package:pneu/features/map/domain/usecases/get_events_for_bounds.dart';
import 'package:pneu/features/map/domain/usecases/get_pending_events.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pneu/features/login/domain/entities/user.dart' as user;

class EventsStore extends m.ChangeNotifier {
  EventsStore(
      {required GetEventsForBounds getEventsForBounds,
      required AddEvent addEvent,
      required GetPendingEvents getPendingEvents,
      required ApproveEvent approveEvent})
      : _getEventsForBounds = getEventsForBounds,
        _addEvent = addEvent,
        _getPendingEvents = getPendingEvents,
        _approveEvent = approveEvent;
  GetEventsForBounds _getEventsForBounds;
  AddEvent _addEvent;
  GetPendingEvents _getPendingEvents;
  ApproveEvent _approveEvent;

  List<Event> shownEvents = List.empty(growable: true);
  List<Event> adminEvents = List.empty(growable: true);

  Future<void> getEventsForBounds(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng) async {
    final fresh = await _getEventsForBounds(sw_lat, sw_lng, ne_lat, ne_lng);

    final freshIds = fresh.map((e) => e.id).toSet();

    shownEvents.removeWhere((e) => !freshIds.contains(e.id));

    for (final e in fresh) {
      if (!shownEvents.any((old) => old.id == e.id)) {
        shownEvents.add(e);
      }
    }

    notifyListeners();
  }

  Future<void> addEvent(double lat, double lng, int category, String userId,
      String description) async {
    final addedEvent = await _addEvent(lat, lng, category, userId, description);
    shownEvents.add(addedEvent);
    notifyListeners();
  }

  Future<void> getPendingEvents() async {
    adminEvents.clear();
    final events = await _getPendingEvents();
    print("PENDING EVENTS: ${events}");
    adminEvents.addAll(events);
    notifyListeners();
  }

  Future<void> approveEvent(Event event, user.User user) async {
    final approvedEvent = await _approveEvent(event, user);
    await getPendingEvents();
  }
}
