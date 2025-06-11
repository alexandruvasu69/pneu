import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pneu/shared/models/users/AppUser.dart';
import 'package:pneu/shared/models/users/AuthUser.dart';
import 'package:pneu/shared/services/api/api_general_access.dart';
import 'package:pneu/shared/services/api/api_service.dart';

class UserService {
  final routeUrl = 'http://10.0.2.2:54321';

  Future<AppUser> getOrCreateGuestUser() async {
    ApiService api = ApiGeneralAccess('/rest/v1/rpc/get_or_create_guest_user', {
      "p_username": 'test_username',
    });

    http.Response response = await api.post();

    final data = jsonDecode(response.body);

    print("Data: " + data.toString());
    if (data is List && data.isNotEmpty) {
      final AppUser user = AppUser.fromJson(data[0]);
      return user;
    } else {
      throw Exception('RPC nu a returnat datele așteptate');
    }
  }

  Future<AppUser> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    ApiService api = ApiGeneralAccess('/auth/v1/signup', <String, dynamic>{
      'email': email,
      'password': password,
      'options': {
        'data': {
          'username': username ?? '',
        }
      }
    });

    http.Response response = await api.post();

    final data = jsonDecode(response.body);
    if (data is List && data.isNotEmpty) {
      final AppUser user = AppUser.fromJson(data[0]);
      return user;
    } else {
      throw Exception('RPC nu a returnat datele așteptate');
    }
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    ApiService api = ApiGeneralAccess('/auth/v1/token?grant_type=password', <String, dynamic>{
      "email": email,
      "password": password,
    });

    http.Response response = await api.post();

    print("RESPONSE: " + response.body);

    final data = jsonDecode(response.body);
    print('SignIn data: $data');
    if (data != null && data is Map<String, dynamic>) {
      final AppUser user = AppUser.fromJson(data);

      final extraData = await fetchExtraUserData(userId: user.id);

      print("Extra DATA: " + extraData.toString());

      if (extraData != null && extraData is Map<String, dynamic>) {
        user.username = extraData['username'];
        user.role = extraData['user_type'];
      }

      return user;
    } else {
      throw Exception('RPC nu a returnat datele așteptate');
    }
  }

  Future<Map<String, dynamic>> fetchExtraUserData({required userId}) async {
    ApiService api = ApiGeneralAccess('/rest/v1/profiles?select=user_type,username&user_id=eq.$userId', null);
    print("Fetching extra data....");

    http.Response response = await api.get();

    print("RESPONSE 4: " + response.body);

    return jsonDecode(response.body)[0];
  }
}
