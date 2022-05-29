enum AuthErrorCode {
  notAuth,
  notExists,
  connection,
}

class AuthException implements Exception {
  AuthException({required this.error, this.message = ""});

  final AuthErrorCode error;
  final String message;
}
