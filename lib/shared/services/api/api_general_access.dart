import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pneu/shared/services/api/api_service.dart';

class ApiGeneralAccess extends ApiService {
  ApiGeneralAccess(super.url, super.body);

  @override
  Future<http.Response> post() async {
    final Uri uri = Uri.parse('$url/$route');

    final http.Response response = await http.post(
      uri,
      headers: {
        'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    print("RESPONSE 2:" + response.body);

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }

    return response;
  }

  @override
  Future<http.Response> get() async {
    final Uri uri = Uri.parse('$url/$route');

    final http.Response response = await http.get(
      uri,
      headers: {
        'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }

    return response;
  }
}
