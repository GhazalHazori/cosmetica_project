class SignupEntity {
  final String fullName;
  final String phone;
  final String password;
  final String? email;

  /// Language the verification SMS is composed in (`ar` or `en`).
  final String language;

  const SignupEntity({
    required this.fullName,
    required this.phone,
    required this.password,
    this.email,
    this.language = 'ar',
  });
}
