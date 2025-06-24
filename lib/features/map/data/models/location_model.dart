import 'package:pneu/features/map/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel(
      {required super.id,
      required super.address1,
      required super.address2,
      required super.latitude,
      required super.longitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        id: json['features'][0]['id'] as String,
        address1: json['features'][0]['properties']['context']['address']
            ['name'] as String,
        address2:
            json['features'][0]['properties']['place_formatted'] as String,
        latitude: json['features'][0]['geometry']['coordinates'][1] as double,
        longitude: json['features'][0]['geometry']['coordinates'][0] as double);
  }
}
