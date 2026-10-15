import '../../domain/entities/signup_entity.dart';

/// Body of `POST /api/shop/auth/register/` for an individual account.
class SignupModel extends SignupEntity {
  const SignupModel({
    required super.fullName,
    required super.phone,
    required super.password,
    super.email,
    super.language,
  });

  factory SignupModel.fromEntity(SignupEntity entity) {
    return SignupModel(
      fullName: entity.fullName,
      phone: entity.phone,
      password: entity.password,
      email: entity.email,
      language: entity.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'password': password,
      if (email != null && email!.isNotEmpty) 'email': email,
      'language': language,
      'is_business': false,
    };
  }
}
