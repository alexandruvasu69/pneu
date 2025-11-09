import 'package:pneu/features/map/data/models/route_segment_model.dart';
import 'package:pneu/features/map/domain/entities/route.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class RouteModel extends Route {
  RouteModel(
      {required super.routeSegments,
      required super.routeId,
      required super.start,
      required super.end});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final segmentsJson = json['segments'] as List<dynamic>;
    final routeSegments = segmentsJson
        .map((e) => RouteSegmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return RouteModel(
      routeId: json['route_id'],
      start: CustomLatLng(json['start'][1], json['start'][0]),
      end: CustomLatLng(json['end'][1], json['end'][0]),
      routeSegments: routeSegments,
    );
  }
}
