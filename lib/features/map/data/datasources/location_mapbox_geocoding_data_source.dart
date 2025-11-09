import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class LocationMapboxGeocodingDataSource {
  Future<Map<String, dynamic>?> getLocationReverse(
      double lat, double lng) async {
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

  Future<Either<AppException, List<dynamic>>> suggestLocation(
      String location, User user, CustomLatLng position) async {
    final Uri url = Uri.parse(
      'https://api.mapbox.com/search/searchbox/v1/suggest'
      '?q=${location}&session_token=${user.id}&proximity=${position.longitude},${position.latitude}&country=RO&bbox=25.90,44.30,26.30,44.60&types=street,address'
      '&access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right(body['suggestions']);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, Map<String, dynamic>>> retrieveLocation(
      String id, User user) async {
    final Uri url = Uri.parse(
      'https://api.mapbox.com/search/searchbox/v1/retrieve/$id'
      '?session_token=${user.id}'
      '&access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
    );

    print("URL: ${url.toString()}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("BODY: ${body}");
        return Either.right(body);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }
}
