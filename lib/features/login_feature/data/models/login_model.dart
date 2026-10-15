import '../../domain/entities/login_entity.dart';

/// Body of `POST /api/auth/sign-in/`.
class LoginModel extends LoginEntity {
  const LoginModel({
    required super.identifier,
    required super.password,
  });

  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(
      identifier: entity.identifier,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}
