import 'package:pneu/features/map/data/models/event_model.dart';
import 'package:pneu/features/map/domain/entities/route_segment.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class RouteSegmentModel extends RouteSegment {
  RouteSegmentModel(
      {required super.seq,
      required super.coordinates,
      super.safetyCategory,
      super.mode,
      required super.events,
      super.highway});

  factory RouteSegmentModel.fromJson(Map<String, dynamic> json) {
    print("SEGMENT PROBLEM: ${json}");
    return RouteSegmentModel(
      seq: json['seq'] as int,
      coordinates: (json['geom']['coordinates'] as List<dynamic>)
          .map((c) => CustomLatLng(c[1], c[0]))
          .toList(),
      safetyCategory: json['lts'] as int?,
      mode: json['mode'] as String?,
      events: (json['events'] as List<dynamic>)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      highway: json['highway'] as String?,
    );
  }
}
