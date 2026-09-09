class SignupEntity {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool agreeToTerms;
  final String? accountType;

  const SignupEntity({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.agreeToTerms,
    this.accountType,
  });
}
