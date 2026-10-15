/// Low-level exceptions thrown by data sources.
///
/// These must be converted to [Failure] instances in repositories.
class ServerException implements Exception {
  final String message;

  /// HTTP status code, when the server answered.
  final int? statusCode;

  /// Machine-readable error code from the API body (e.g. `otp_error`).
  final String? code;

  ServerException(this.message, {this.statusCode, this.code});
}

/// The server could not be reached (no connection, timeout, ...).
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = '']);
}
