import 'package:pneu/shared/models/custom_lat_lng.dart';

abstract class Event {
  Event({
    required this.id,
    required this.subtypeId,
    required this.edgeId,
    this.description,
    required this.geometry,
    required this.status,
    this.createdAt,
    required this.createdBy,
  });

  final int id;
  final int subtypeId;
  final int edgeId;
  final String? description;
  final CustomLatLng geometry;
  final String status;
  final String? createdAt;
  final String createdBy;
}
