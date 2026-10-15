import 'package:shared_preferences/shared_preferences.dart';

/// Persists the access / refresh token pair returned on sign-in.
abstract class TokenStorage {
  String? get accessToken;
  String? get refreshToken;
  bool get hasSession;

  /// When the current access token was saved; used to schedule refreshes.
  DateTime? get accessTokenSavedAt;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Stores a refreshed access token (and a rotated refresh token, if any).
  Future<void> saveAccessToken(String accessToken, {String? refreshToken});

  Future<void> clear();
}

class SharedPrefsTokenStorage implements TokenStorage {
  SharedPrefsTokenStorage(this._prefs);

  static const String _accessKey = 'auth.access_token';
  static const String _refreshKey = 'auth.refresh_token';
  static const String _savedAtKey = 'auth.access_token_saved_at';

  final SharedPreferences _prefs;

  @override
  String? get accessToken => _prefs.getString(_accessKey);

  @override
  String? get refreshToken => _prefs.getString(_refreshKey);

  @override
  bool get hasSession => accessToken != null;

  @override
  DateTime? get accessTokenSavedAt {
    final millis = _prefs.getInt(_savedAtKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_refreshKey, refreshToken);
    await saveAccessToken(accessToken);
  }

  @override
  Future<void> saveAccessToken(
    String accessToken, {
    String? refreshToken,
  }) async {
    await _prefs.setString(_accessKey, accessToken);
    await _prefs.setInt(_savedAtKey, DateTime.now().millisecondsSinceEpoch);
    if (refreshToken != null) {
      await _prefs.setString(_refreshKey, refreshToken);
    }
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_accessKey);
    await _prefs.remove(_refreshKey);
    await _prefs.remove(_savedAtKey);
  }
}
