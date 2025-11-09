import 'package:pneu/features/map/domain/entities/location.dart';

class SavedLocationModel extends Location {
  SavedLocationModel({
    required super.id,
    required super.address1,
    required super.address2,
    super.latitude,
    super.longitude,
  });

  factory SavedLocationModel.fromJson(Map<String, dynamic> json) {
    final coords = (json['coords']['coordinates'] as List<dynamic>).cast<num>();
    final lon = coords.isNotEmpty ? coords[0].toDouble() : 0.0;
    final lat = coords.length > 1 ? coords[1].toDouble() : 0.0;

    return SavedLocationModel(
      id: json['id'],
      address1: json['address1'],
      address2: json['address2'],
      latitude: lat,
      longitude: lon,
    );
  }
}
