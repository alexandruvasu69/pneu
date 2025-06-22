import 'dart:convert';
import 'package:http/http.dart';
import 'package:pneu/shared/services/api/api_general_access.dart';
import 'package:pneu/shared/services/api/api_service.dart';

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
    ApiService api = ApiGeneralAccess('/auth/v1/token?grant_type=password', <String, dynamic>{
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
}
