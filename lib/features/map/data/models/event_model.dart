import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.subtypeId,
    required super.edgeId,
    super.description,
    required super.geometry,
    required super.status,
    super.createdAt,
    required super.createdBy,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
        id: json['id'] as int,
        subtypeId: json['subtype_id'] as int,
        edgeId: json['edge_id'] as int,
        description: json['description'] as String?,
        geometry: CustomLatLng(
            json['geom']['coordinates'][1], json['geom']['coordinates'][0]),
        status: json['status'] as String,
        createdAt: json['created_at'] as String?,
        createdBy: json['created_by'] as String);
  }
}
