import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationMapboxGeocodingDataSource {
  Future<Map<String, dynamic>?> getLocation(double lat, double lng) async {
    final Uri url = Uri.parse(
      'https://api.mapbox.com/search/geocode/v6/reverse'
      '?longitude=$lng&latitude=$lat'
      '&access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }

    return jsonDecode(response.body);
  }
}
