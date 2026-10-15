import 'package:dio/dio.dart';

import 'api_constants.dart';
import 'token_storage.dart';

/// Exchanges the stored refresh token for a new access token via
/// `POST /api/auth/refresh/`.
class TokenRefresher {
  TokenRefresher({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  /// A bare client: the refresh call must not pass through [AuthInterceptor].
  factory TokenRefresher.withBaseUrl({
    required TokenStorage tokenStorage,
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    return TokenRefresher(
      tokenStorage: tokenStorage,
      dio: Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          headers: {'Accept': 'application/json'},
        ),
      ),
    );
  }

  final TokenStorage _tokenStorage;
  final Dio _dio;

  /// Returns whether a new access token was stored.
  ///
  /// If the refresh token is rejected (revoked, expired, password changed or
  /// account suspended) the session is cleared. Network failures leave it
  /// untouched.
  Future<bool> refresh() async {
    final refreshToken = _tokenStorage.refreshToken;
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: {'refresh': refreshToken},
      );
      final access = response.data?['access'] as String?;
      if (access == null) return false;

      await _tokenStorage.saveAccessToken(
        access,
        refreshToken: response.data?['refresh'] as String?,
      );
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokenStorage.clear();
      }
      return false;
    }
  }
}
