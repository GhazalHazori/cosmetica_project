import '../../domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  const SignupModel({
    required super.username,
    required super.email,
    required super.phone,
    required super.password,
    required super.confirmPassword,
    required super.agreeToTerms,
    super.accountType,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      agreeToTerms: json['agreeToTerms'] as bool,
      accountType: json['accountType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
      'agreeToTerms': agreeToTerms,
      'accountType': accountType,
    };
  }
}
