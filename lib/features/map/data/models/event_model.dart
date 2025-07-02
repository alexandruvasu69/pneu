import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class EventModel extends Event {
  EventModel({
    required super.id,
    required super.subtypeId,
    required super.edgeId,
    required super.description,
    required super.geometry,
    required super.status,
    required super.createdAt,
    required super.createdBy,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
        id: json['id'] as int,
        subtypeId: json['subtype_id'] as int,
        edgeId: json['edge_id'] as int,
        description: json['description'] as String,
        geometry: json['geom'] as CustomLatLng,
        status: json['status'] as String,
        createdAt: json['created_at'] as DateTime,
        createdBy: json['created_by'] as String);
  }
}
