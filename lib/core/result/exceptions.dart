abstract class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([String msg = 'Eroare de retea!']) : super(msg);
}

class ServerException extends AppException {
  ServerException(int statusCode) : super('Server returned HTTP ${statusCode}');
}

class ParsingException extends AppException {
  ParsingException([String msg = 'Eroare la parsarea datelor']) : super(msg);
}
