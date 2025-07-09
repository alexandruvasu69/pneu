abstract class Location {
  Location({
    required this.id,
    required this.address1,
    required this.address2,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String address1;
  final String address2;
  final double? latitude;
  final double? longitude;
}
