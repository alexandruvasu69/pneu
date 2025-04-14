class CustomLatLng {
  const CustomLatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  String toString() {
    return 'Customlatlng(latitude: $latitude, longitude: $longitude)';
  }
}
