import 'package:pneu/features/map/domain/entities/location.dart';

class SavedLocationModel extends Location {
  SavedLocationModel({
    required super.id,
    required super.address1,
    required super.address2,
    required super.latitude,
    required super.longitude,
  });

  factory SavedLocationModel.fromJson(Map<String, dynamic> json) {
    return SavedLocationModel(
      id: json['id'],
      address1: json['address1'],
      address2: json['address2'],
      latitude: json['coords']['coordinates'][1],
      longitude: json['coords']['coordinates'][0],
    );
  }
}
