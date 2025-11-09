import 'package:pneu/features/map/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.address1,
    required super.address2,
    super.latitude,
    super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final List features = json['features'] as List;

    Map<String, dynamic>? chosen =
        features.cast<Map<String, dynamic>>().firstWhere(
              (f) => f['properties']['feature_type'] == 'address',
              orElse: () => {},
            );

    if (chosen.isEmpty) {
      chosen = features.cast<Map<String, dynamic>>().firstWhere(
            (f) => f['properties']['feature_type'] == 'street',
            orElse: () => {},
          );
    }

    if (chosen.isEmpty) {
      chosen = features.cast<Map<String, dynamic>>().firstWhere(
            (f) => f['properties']['feature_type'] == 'postcode',
            orElse: () => {},
          )!;
    }

    if (chosen.isEmpty) {
      throw Exception('No suitable feature found in response');
    }

    final props = chosen['properties'] as Map<String, dynamic>;
    final geom = chosen['geometry'] as Map<String, dynamic>;

    final id = chosen['id'] as String;

    final address1 =
        (props['context'] != null && props['context']['address'] != null)
            ? props['context']['address']['name'] as String
            : props['name'] as String;

    final address2 = props['place_formatted'] as String? ?? 'unknown place';

    final coords = geom['coordinates'] as List;
    final longitude = coords[0];
    final latitude = coords[1];

    return LocationModel(
      id: id,
      address1: address1,
      address2: address2,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
