import 'package:pneu/features/map/domain/entities/route_segment.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

abstract class Route {
  Route(
      {required this.routeId,
      required this.start,
      required this.end,
      required this.routeSegments});

  final String routeId;
  final CustomLatLng start;
  final CustomLatLng end;
  final List<RouteSegment> routeSegments;

  @override
  String toString() {
    return routeSegments.toString();
  }
}
