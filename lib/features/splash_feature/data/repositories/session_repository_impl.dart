import '../../../../core/network/token_refresher.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({
    required TokenStorage tokenStorage,
    required TokenRefresher tokenRefresher,
    this.refreshTimeout = const Duration(seconds: 8),
  })  : _tokenStorage = tokenStorage,
        _tokenRefresher = tokenRefresher;

  final TokenStorage _tokenStorage;
  final TokenRefresher _tokenRefresher;

  /// How long the splash screen waits for the server before moving on.
  final Duration refreshTimeout;

  @override
  Future<bool> restoreSession() async {
    if (!_tokenStorage.hasSession) return false;

    // Offline or slow server: keep the stored session and let the API
    // client refresh it on the next request.
    await _tokenRefresher
        .refresh()
        .timeout(refreshTimeout, onTimeout: () => false);

    // A rejected refresh token clears the storage.
    return _tokenStorage.hasSession;
  }
}
