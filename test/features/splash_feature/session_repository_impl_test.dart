import 'package:cosmetica_project/core/network/token_refresher.dart';
import 'package:cosmetica_project/features/splash_feature/data/repositories/session_repository_impl.dart';
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

  (SessionRepositoryImpl, FakeAdapter) build(
    FakeResponse Function(dynamic) refresh,
  ) {
    final adapter = FakeAdapter(refresh);
    final repository = SessionRepositoryImpl(
      tokenStorage: storage,
      tokenRefresher: TokenRefresher(
        tokenStorage: storage,
        dio: fakeDio(adapter),
      ),
    );
    return (repository, adapter);
  }

  test('no stored token: not signed in, no request', () async {
    storage.accessToken = null;
    final (repository, adapter) = build((_) => (200, {'access': 'x'}));

    expect(await repository.restoreSession(), isFalse);
    expect(adapter.requests, isEmpty);
  });

  test('stored token is refreshed and the user stays signed in', () async {
    final (repository, adapter) =
        build((_) => (200, {'access': 'new-access'}));

    expect(await repository.restoreSession(), isTrue);
    expect(adapter.requests, hasLength(1));
    expect(storage.accessToken, 'new-access');
  });

  test('rejected refresh token signs the user out', () async {
    final (repository, _) = build((_) => (401, {'detail': 'invalid'}));

    expect(await repository.restoreSession(), isFalse);
    expect(storage.hasSession, isFalse);
  });

  test('server error keeps the stored session', () async {
    final (repository, _) = build((_) => (500, {'detail': 'down'}));

    expect(await repository.restoreSession(), isTrue);
    expect(storage.accessToken, 'old-access');
  });
}
