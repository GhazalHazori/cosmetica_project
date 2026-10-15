import 'auth_user_model.dart';

/// Response of `POST /api/auth/sign-in/`.
class SignInResponseModel {
  final String accessToken;
  final String refreshToken;
  final AuthUserModel account;

  const SignInResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.account,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      accessToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
      account: AuthUserModel.fromJson(json['account'] as Map<String, dynamic>),
    );
  }
}
