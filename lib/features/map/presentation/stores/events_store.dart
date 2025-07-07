import 'package:flutter/material.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/features/map/domain/usecases/add_event.dart';
import 'package:pneu/features/map/domain/usecases/get_events_for_bounds.dart';

class EventsStore extends ChangeNotifier {
  EventsStore(
      {required GetEventsForBounds getEventsForBounds,
      required AddEvent addEvent})
      : _getEventsForBounds = getEventsForBounds,
        _addEvent = addEvent;
  GetEventsForBounds _getEventsForBounds;
  AddEvent _addEvent;

  List<Event> shownEvents = List.empty(growable: true);

  Future<void> getEventsForBounds(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng) async {
    final events = await _getEventsForBounds(sw_lat, sw_lng, ne_lat, ne_lng);
    shownEvents.addAll(events);
    notifyListeners();
  }

  Future<void> addEvent(double lat, double lng, int category, String userId,
      String description) async {
    final addedEvent = await _addEvent(lat, lng, category, userId, description);
    shownEvents.add(addedEvent);
    notifyListeners();
  }
}
