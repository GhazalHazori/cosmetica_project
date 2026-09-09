class BusinessSignupEntity {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String? commercialRegisterFile;
  final bool agreeToTerms;

  const BusinessSignupEntity({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    this.commercialRegisterFile,
    required this.agreeToTerms,
  });
}
