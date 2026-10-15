import 'dart:convert';
import 'dart:typed_data';

import 'package:cosmetica_project/core/network/token_storage.dart';
import 'package:dio/dio.dart';

class MemoryTokenStorage implements TokenStorage {
  @override
  String? accessToken;
  @override
  String? refreshToken;
  @override
  DateTime? accessTokenSavedAt;

  @override
  bool get hasSession => accessToken != null;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.refreshToken = refreshToken;
    await saveAccessToken(accessToken);
  }

  @override
  Future<void> saveAccessToken(String accessToken,
      {String? refreshToken}) async {
    this.accessToken = accessToken;
    accessTokenSavedAt = DateTime.now();
    if (refreshToken != null) this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    accessTokenSavedAt = null;
  }
}

typedef FakeResponse = (int, Map<String, dynamic>);

/// Answers every request with [handler] and records what was sent.
/// A handler that throws simulates a network failure.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final FakeResponse Function(RequestOptions) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = handler(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio fakeDio(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
