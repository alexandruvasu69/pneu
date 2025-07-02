import 'package:pneu/features/map/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.address1,
    required super.address2,
    required super.latitude,
    required super.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final List features = json['features'] as List;

    // 1) întâi cautăm un feature de tipul „address”
    Map<String, dynamic>? chosen =
        features.cast<Map<String, dynamic>>().firstWhere(
              (f) => f['properties']['feature_type'] == 'address',
              orElse: () => {},
            );

    // 2) dacă nu e „address”, căutăm un „street”
    if (chosen.isEmpty) {
      chosen = features.cast<Map<String, dynamic>>().firstWhere(
            (f) => f['properties']['feature_type'] == 'street',
            orElse: () => {},
          );
    }

    // 3) dacă nici street nu există, poți face fallback la postcode/place etc.
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

    // Cum extragi id-ul – vine ca string
    final id = chosen['id'] as String;

    // address1 = numărul/strada dacă există
    final address1 =
        (props['context'] != null && props['context']['address'] != null)
            ? props['context']['address']['name'] as String
            : props['name'] as String;

    // address2 = full_address / place_formatted
    final address2 = props['place_formatted'] as String? ?? 'unknown place';

    final coords = geom['coordinates'] as List;
    final longitude = coords[0] as double;
    final latitude = coords[1] as double;

    return LocationModel(
      id: id,
      address1: address1,
      address2: address2,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
