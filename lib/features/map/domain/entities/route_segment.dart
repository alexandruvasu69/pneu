import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

abstract class RouteSegment {
  RouteSegment(
      {required this.seq,
      required this.coordinates,
      this.safetyCategory,
      this.mode,
      required this.events,
      this.highway});

  final int seq;
  final List<CustomLatLng> coordinates;
  final int? safetyCategory;
  final String? mode;
  final List<Event> events;
  final String? highway;

  @override
  String toString() {
    return this.coordinates.toString();
  }
}
