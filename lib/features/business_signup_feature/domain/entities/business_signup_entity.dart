class BusinessSignupEntity {
  final String fullName;
  final String phone;
  final String password;
  final String? email;

  /// Local path of the commercial register document (PNG, JPG or PDF, ≤ 10 MB).
  final String commercialRegisterFilePath;

  /// Language the verification SMS is composed in (`ar` or `en`).
  final String language;

  const BusinessSignupEntity({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.commercialRegisterFilePath,
    this.email,
    this.language = 'ar',
  });
}
