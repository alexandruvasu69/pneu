import 'package:pneu/features/map/domain/entities/location.dart';

class RetrievedLocationModel extends Location {
  RetrievedLocationModel(
      {required super.id,
      required super.address1,
      required super.address2,
      super.latitude,
      super.longitude});

  factory RetrievedLocationModel.fromJson(Map<String, dynamic> json) {
    final feature = json['features'][0];

    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final coords =
        (geometry['coordinates'] as List<dynamic>? ?? []).cast<num>();
    final double? lon = coords.isNotEmpty ? coords[0].toDouble() : null;
    final double? lat = coords.length > 1 ? coords[1].toDouble() : null;

    final props = feature['properties'] as Map<String, dynamic>? ?? {};

    final id = props['mapbox_id'] as String? ?? '';

    final address1 =
        props['address'] as String? ?? props['name'] as String? ?? '';

    final address2 = props['place_formatted'] as String? ??
        props['place']['name'] as String? ??
        '';

    return RetrievedLocationModel(
      id: id,
      address1: address1,
      address2: address2,
      latitude: lat,
      longitude: lon,
    );
  }
}
