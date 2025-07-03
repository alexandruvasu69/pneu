import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/location.dart';

class SavedLocationsSupabaseDatasource {
  Future<Either<AppException, Map<String, dynamic>>> saveLocation(
      Location location, User user) async {
    final Uri url =
        Uri.parse('${dotenv.env['SUPABASE_URL']}/rest/v1/saved_locations');

    final body = {
      'user_id': user.id,
      'address1': location.address1,
      'address2': location.address2,
      'coords': {
        'type': 'Point',
        'coordinates': [location.longitude, location.latitude],
      },
    };

    try {
      final http.Response response = await http.post(
        url,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          //   'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
        },
        // ignore: always_specify_types
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final List<dynamic> body = jsonDecode(response.body);
        return Either.right(body[0]);
      } else {
        return Either.left(
            ServerException(response.body + response.statusCode.toString()));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, List<dynamic>>> getSavedLocations(
      User user) async {
    print("TEST");

    final uri =
        Uri.parse('${dotenv.env['SUPABASE_URL']!}/rest/v1/saved_locations'
            '?select=*,coords&user_id=eq.${user.id}');

    try {
      print("SAVED LOCATIONS:");

      final http.Response response = await http.get(
        uri,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          //   'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
        },
      );

      print("SAVED LOCATIONS:");

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);

        return Either.right(body);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      print("ERROR $e");

      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, bool>> deleteSavedLocation(
      Location location) async {
    final uri = Uri.parse(
      '${dotenv.env['SUPABASE_URL']!}/rest/v1/saved_locations'
      '?id=eq.${location.id}',
    );

    try {
      final http.Response response = await http.delete(
        uri,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        return Either.right(true);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }
}
