import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';

class RoutesSupabaseDatasource {
  Future<Either<AppException, List<dynamic>>> getRoutes(
      double startLat, double startLng, double endLat, double endLng) async {
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/calculate_shortest_route');

    try {
      final http.Response response = await http.post(
        url,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          'Content-Type': 'application/json',
        },
        // ignore: always_specify_types
        body: jsonEncode({
          'start_lon': startLng,
          'start_lat': startLat,
          'end_lon': endLng,
          'end_lat': endLat,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right([body]);
      } else {
        return Either.left(ServerException(response.statusCode));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }
}
