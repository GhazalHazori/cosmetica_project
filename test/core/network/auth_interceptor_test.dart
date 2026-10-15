import 'package:cosmetica_project/core/network/api_constants.dart';
import 'package:cosmetica_project/core/network/auth_interceptor.dart';
import 'package:cosmetica_project/core/network/token_refresher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_network.dart';

void main() {
  late MemoryTokenStorage storage;

  setUp(() {
    storage = MemoryTokenStorage()
      ..accessToken = 'old-access'
      ..refreshToken = 'refresh-1'
      ..accessTokenSavedAt = DateTime.now();
  });

  (Dio, FakeAdapter, FakeAdapter) build({
    required FakeResponse Function(RequestOptions) api,
    required FakeResponse Function(RequestOptions) refresh,
  }) {
    final apiAdapter = FakeAdapter(api);
    final refreshAdapter = FakeAdapter(refresh);
    final dio = fakeDio(apiAdapter);
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: storage,
        tokenRefresher: TokenRefresher(
          tokenStorage: storage,
          dio: fakeDio(refreshAdapter),
        ),
      ),
    );
    return (dio, apiAdapter, refreshAdapter);
  }

  test('refreshes before the request once the token is 24 hours old',
      () async {
    storage.accessTokenSavedAt =
        DateTime.now().subtract(const Duration(hours: 24, minutes: 1));
    final (dio, api, refresh) = build(
      api: (_) => (200, {'ok': true}),
      refresh: (_) => (200, {'access': 'new-access'}),
    );

    await dio.get<dynamic>('/api/auth/me/');

    expect(refresh.requests.single.path, ApiConstants.refreshToken);
    expect(refresh.requests.single.data, {'refresh': 'refresh-1'});
    expect(api.requests.single.headers['Authorization'], 'Bearer new-access');
    expect(storage.accessToken, 'new-access');
  });

  test('does not refresh a token younger than 24 hours', () async {
    final (dio, api, refresh) = build(
      api: (_) => (200, {'ok': true}),
      refresh: (_) => (200, {'access': 'new-access'}),
    );

    await dio.get<dynamic>('/api/auth/me/');

    expect(refresh.requests, isEmpty);
    expect(api.requests.single.headers['Authorization'], 'Bearer old-access');
  });

  test('on 401 refreshes once and retries with the new token', () async {
    final (dio, api, refresh) = build(
      api: (o) => o.headers['Authorization'] == 'Bearer new-access'
          ? (200, {'ok': true})
          : (401, {'detail': 'expired'}),
      refresh: (_) => (200, {'access': 'new-access'}),
    );

    final response = await dio.get<dynamic>('/api/auth/me/');

    expect(response.statusCode, 200);
    expect(refresh.requests, hasLength(1));
    expect(api.requests, hasLength(2));
  });

  test('clears the session when the refresh token is rejected', () async {
    final (dio, _, _) = build(
      api: (_) => (401, {'detail': 'expired'}),
      refresh: (_) => (401, {'detail': 'invalid'}),
    );

    await expectLater(
      dio.get<dynamic>('/api/auth/me/'),
      throwsA(isA<DioException>()),
    );
    expect(storage.hasSession, isFalse);
    expect(storage.refreshToken, isNull);
  });

  test('does not refresh on a 401 from an unauthenticated request', () async {
    storage
      ..accessToken = null
      ..accessTokenSavedAt = null;
    final (dio, _, refresh) = build(
      api: (_) => (401, {'detail': 'Those credentials are not correct.'}),
      refresh: (_) => (200, {'access': 'new-access'}),
    );

    await expectLater(
      dio.post<dynamic>(ApiConstants.signIn),
      throwsA(isA<DioException>()),
    );
    expect(refresh.requests, isEmpty);
  });
}
