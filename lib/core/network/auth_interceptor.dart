import 'package:dio/dio.dart';

import 'token_refresher.dart';
import 'token_storage.dart';

/// Attaches the access token and keeps it fresh via [TokenRefresher].
///
/// - Before a request, if the access token is older than [refreshInterval]
///   (24 hours by default), it is refreshed first.
/// - If an authenticated request still gets a 401 (access tokens are
///   short-lived), the token is refreshed once and the request retried.
/// - If the refresh token itself is rejected, the session is cleared.
///
/// Being a [QueuedInterceptor], concurrent requests wait for a single refresh
/// instead of each starting their own.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required TokenRefresher tokenRefresher,
    this.refreshInterval = const Duration(hours: 24),
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _tokenRefresher = tokenRefresher;

  static const String _retriedKey = 'auth_retried';

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;
  final Duration refreshInterval;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_tokenStorage.hasSession && _isRefreshDue) {
      // A failure here is not fatal: the request goes out with the current
      // token and the 401 path below gets another chance.
      await _tokenRefresher.refresh();
    }

    final token = _tokenStorage.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final sentAuth = request.headers['Authorization'] as String?;

    // Only authenticated requests are retried; a 401 from sign-in means
    // wrong credentials, not an expired token.
    if (err.response?.statusCode != 401 ||
        sentAuth == null ||
        request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    // Another queued request may already have refreshed the token.
    final alreadyRefreshed = sentAuth != 'Bearer ${_tokenStorage.accessToken}';
    if (!alreadyRefreshed && !await _tokenRefresher.refresh()) {
      return handler.next(err);
    }

    final token = _tokenStorage.accessToken;
    if (token == null) {
      return handler.next(err);
    }

    request.extra[_retriedKey] = true;
    request.headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await _dio.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool get _isRefreshDue {
    final savedAt = _tokenStorage.accessTokenSavedAt;
    return savedAt == null ||
        DateTime.now().difference(savedAt) >= refreshInterval;
  }
}
