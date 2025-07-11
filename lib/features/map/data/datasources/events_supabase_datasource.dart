import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pneu/core/result/either.dart';
import 'package:pneu/core/result/exceptions.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/features/map/domain/entities/event.dart';
import 'package:pneu/shared/models/custom_lat_lng.dart';

class EventsSupabaseDatasource {
  Future<Either<AppException, List<dynamic>>> getEventsForBounds(
      double sw_lat, double sw_lng, double ne_lat, double ne_lng) async {
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/get_events_for_bounds');

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
          "sw_lon": sw_lng,
          "sw_lat": sw_lat,
          "ne_lon": ne_lng,
          "ne_lat": ne_lat
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right(body);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, Map<String, dynamic>>> addEvent(double lat,
      double lng, int category, String userId, String description) async {
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/insert_event_for_position');

    try {
      final http.Response response = await http.post(
        url,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          'Content-Type': 'application/json',
          'Prefer': 'return=representation'
        },
        // ignore: always_specify_types
        body: jsonEncode({
          "lon": lng,
          "lat": lat,
          "p_subtype_id": category,
          "user_id": userId,
          "p_description": description
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right(body[0]);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, List<dynamic>>> getPendingEvents() async {
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/events?status=eq.pending');

    try {
      final http.Response response = await http.get(
        url,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right(body);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }

  Future<Either<AppException, Map<String, dynamic>>> approveEvent(
      Event event, User user) async {
    print("EVENT ID: ${event.id}");
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/rest/v1/events?id=eq.${event.id}');

    try {
      final http.Response response = await http.patch(
        url,
        // ignore: always_specify_types
        headers: {
          'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
          'Authorization': 'Bearer ${user.token}'
        },
        // ignore: always_specify_types
        body: jsonEncode({"status": "approved"}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return Either.right(body[0]);
      } else {
        return Either.left(ServerException(response.body));
      }
    } catch (e) {
      return Either.left(NetworkException(
          "Conextion error! Please check your connection to the internet!"));
    }
  }
}
