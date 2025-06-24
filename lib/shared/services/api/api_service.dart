import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  ApiService(String route, Map<String, dynamic>? body)
      : _route = route,
        _body = body;

  final String url = '${dotenv.env['SUPABASE_URL']}';
  String _route;
  Map<String, dynamic>? _body;

  String get route => _route;
  Map<String, dynamic>? get body => _body;

  set route(String route) {
    if (route.isNotEmpty) _route = route;
  }

  set body(Map<String, dynamic>? body) {
    if (body != null && body.isNotEmpty) _body = body;
  }

  Future<http.Response> post();
  Future<http.Response> get();
}
