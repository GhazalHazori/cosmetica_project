/// Global API configuration: base URL and endpoint paths.
class ApiConstants {
  ApiConstants._();

  /// Customer API. Docs: http://187.7.70.138/api/docs/customer/
  static const String baseUrl = 'http://187.7.70.138';

  // Auth
  static const String register = '/api/shop/auth/register/';
  static const String verify = '/api/shop/auth/verify/';
  static const String resendVerification = '/api/shop/auth/verify/resend/';
  static const String signIn = '/api/auth/sign-in/';
  static const String refreshToken = '/api/auth/refresh/';
  static const String signOut = '/api/auth/sign-out/';

  // Account
  static const String me = '/api/auth/me/';

  /// Makes a media URL from the API absolute (it may come back relative).
  static String? resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '$baseUrl${url.startsWith('/') ? '' : '/'}$url';
  }

  // Password reset (customers)
  static const String passwordResetRequest =
      '/api/auth/password/reset/request/';
  static const String passwordResetVerify = '/api/auth/password/reset/verify/';
  static const String passwordResetComplete =
      '/api/auth/password/reset/complete/';
}
