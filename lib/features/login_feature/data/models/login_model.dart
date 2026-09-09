import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.identifier,
    required super.password,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      identifier: json['identifier'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}
