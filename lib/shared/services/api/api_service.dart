import 'package:http/http.dart' as http;

abstract class ApiService {
  ApiService(String route, Map<String, dynamic>? body)
      : _route = route,
        _body = body;

  final String url = 'http://10.0.2.2:54321';
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
