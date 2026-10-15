import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'token_refresher.dart';
import 'token_storage.dart';

/// Basic REST API client using Dio.
///
/// This class is infrastructure-only. Do not place business logic here.
///
/// When provided, [tokenStorage] adds `Authorization: Bearer <access>` and
/// refreshes the access token through [tokenRefresher] (see
/// [AuthInterceptor]), and [languageCode] adds `Accept-Language` to every
/// request.
class ApiClient {
  ApiClient({
    required String baseUrl,
    TokenStorage? tokenStorage,
    TokenRefresher? tokenRefresher,
    String Function()? languageCode,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout,
            responseType: ResponseType.json,
            headers: {'Accept': 'application/json'},
          ),
        ) {
    if (languageCode != null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Accept-Language'] = languageCode();
            handler.next(options);
          },
        ),
      );
    }
    if (tokenStorage != null) {
      _dio.interceptors.add(
        AuthInterceptor(
          dio: _dio,
          tokenStorage: tokenStorage,
          tokenRefresher: tokenRefresher ??
              TokenRefresher.withBaseUrl(
                tokenStorage: tokenStorage,
                baseUrl: baseUrl,
                connectTimeout: connectTimeout,
                receiveTimeout: receiveTimeout,
              ),
        ),
      );
    }
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // Additional methods (put, delete, etc.) can be added as needed.
}


