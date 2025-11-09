import 'package:pneu/features/map/domain/entities/location.dart';

class SuggestedLocationModel extends Location {
  SuggestedLocationModel(
      {required super.id, required super.address1, required super.address2});

  factory SuggestedLocationModel.fromJson(Map<String, dynamic> json) {
    return SuggestedLocationModel(
      id: (json['mapbox_id'] as String?) ?? 'unknown',
      address1: (json['name'] as String?) ?? 'unknown location',
      address2: (json['place_formatted'] as String?) ?? 'unknown location',
    );
  }
}
