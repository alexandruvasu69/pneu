import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:pneu/features/login/domain/entities/user.dart';
import 'package:pneu/shared/services/api/api_general_access.dart';
import 'package:pneu/shared/services/api/api_service.dart';
import 'package:http/http.dart' as http;

class UserSupabaseDataSource {
  Future<Map<String, dynamic>> getOrCreateGuestUser() async {
    ApiService api = ApiGeneralAccess('/rest/v1/rpc/get_or_create_guest_user', {
      "p_username": 'test_username',
    });

    Response response = await api.post();

    return jsonDecode(response.body)[0];
  }

  Future<Map<String, dynamic>> logIn(
    String email,
    String password,
  ) async {
    ApiService api = ApiGeneralAccess(
        '/auth/v1/token?grant_type=password', <String, dynamic>{
      "email": email,
      "password": password,
    });

    Response response = await api.post();

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
  ) async {
    ApiService api = ApiGeneralAccess('/auth/v1/signup', <String, dynamic>{
      'email': email,
      'password': password,
      'options': {
        'data': {
          'username': '',
        }
      }
    });

    Response response = await api.post();

    return jsonDecode(response.body)[0];
  }

  Future<Map<String, dynamic>> getRole(User user) async {
    final Uri url =
        Uri.parse('${dotenv.env['SUPABASE_URL']}/rest/v1/rpc/get_user_role');

    http.Response response = await http.post(url, headers: {
      'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${user.token}'
    });

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final Uri url = Uri.parse(
        '${dotenv.env['SUPABASE_URL']}/auth/v1/token?grant_type=refresh_token');

    http.Response response = await http.post(
      url,
      headers: {
        'apikey': dotenv.env['SUPABASE_ANON_KEY']!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"refresh_token": refreshToken}),
    );

    return jsonDecode(response.body);
  }
}
