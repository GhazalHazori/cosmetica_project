import 'package:cosmetica_project/core/error/exceptions.dart';
import 'package:cosmetica_project/core/error/failures.dart';
import 'package:cosmetica_project/features/logout_feature/data/datasources/logout_remote_data_source.dart';
import 'package:cosmetica_project/features/logout_feature/data/repositories/logout_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_network.dart';

class _FakeRemote implements LogoutRemoteDataSource {
  final List<String> revoked = [];
  Exception? error;

  @override
  Future<void> signOut(String refreshToken) async {
    revoked.add(refreshToken);
    final e = error;
    if (e != null) throw e;
  }
}

void main() {
  late MemoryTokenStorage storage;
  late _FakeRemote remote;
  late LogoutRepositoryImpl repository;

  setUp(() {
    storage = MemoryTokenStorage()
      ..accessToken = 'access'
      ..refreshToken = 'refresh-1'
      ..accessTokenSavedAt = DateTime.now();
    remote = _FakeRemote();
    repository =
        LogoutRepositoryImpl(remoteDataSource: remote, tokenStorage: storage);
  });

  test('revokes the refresh token and clears the session', () async {
    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    expect(remote.revoked, ['refresh-1']);
    expect(storage.hasSession, isFalse);
    expect(storage.refreshToken, isNull);
  });

  test('a 401 (token already invalid) still signs the user out', () async {
    remote.error = ServerException('not valid', statusCode: 401);

    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    expect(storage.hasSession, isFalse);
  });

  test('no connection keeps the session and reports a failure', () async {
    remote.error = NetworkException();

    final result = await repository.logout();

    expect(result.fold((f) => f, (_) => null), isA<NetworkFailure>());
    expect(storage.accessToken, 'access');
  });

  test('without a refresh token only the local session is cleared', () async {
    storage.refreshToken = null;

    final result = await repository.logout();

    expect(result.isRight(), isTrue);
    expect(remote.revoked, isEmpty);
    expect(storage.hasSession, isFalse);
  });
}
