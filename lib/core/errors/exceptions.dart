class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No Internet Connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {

  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}


