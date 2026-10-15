abstract class SessionRepository {
  /// Refreshes a stored session, if any.
  ///
  /// Returns whether the user is still signed in afterwards: `false` when no
  /// token is stored or the server rejected the refresh token.
  Future<bool> restoreSession();
}
