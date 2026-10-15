import '../../domain/entities/auth_user_entity.dart';

/// `AccountSummary` from the sign-in response.
class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.language,
    required super.principalType,
    required super.state,
    super.email,
    super.photo,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      photo: json['photo'] as String?,
      language: json['language'] as String,
      principalType: json['principal_type'] as String,
      state: json['state'] as String,
    );
  }
}
