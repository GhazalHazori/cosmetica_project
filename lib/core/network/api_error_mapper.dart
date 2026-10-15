import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Converts a [DioException] into the exceptions repositories expect.
///
/// The API answers errors as
/// `{"code": "...", "detail": "...", "errors": {"field": ["message"]}}`.
/// Field messages are localized through `Accept-Language`, so the first one is
/// preferred over `detail`.
Exception mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException();
    default:
      break;
  }

  final response = e.response;
  if (response == null) {
    return NetworkException();
  }

  final data = response.data;
  String? message;
  String? code;

  if (data is Map) {
    code = data['code'] as String?;
    final errors = data['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          message = value.first.toString();
          break;
        }
        if (value is String && value.isNotEmpty) {
          message = value;
          break;
        }
      }
    }
    message ??= data['detail'] as String?;
  }

  return ServerException(
    message ?? '',
    statusCode: response.statusCode,
    code: code,
  );
}
