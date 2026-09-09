import '../../domain/entities/business_signup_entity.dart';

class BusinessSignupModel extends BusinessSignupEntity {
  const BusinessSignupModel({
    required super.username,
    required super.email,
    required super.phone,
    required super.password,
    required super.confirmPassword,
    super.commercialRegisterFile,
    required super.agreeToTerms,
  });

  factory BusinessSignupModel.fromJson(Map<String, dynamic> json) {
    return BusinessSignupModel(
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      commercialRegisterFile: json['commercialRegisterFile'] as String?,
      agreeToTerms: json['agreeToTerms'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
      'commercialRegisterFile': commercialRegisterFile,
      'agreeToTerms': agreeToTerms,
    };
  }
}
