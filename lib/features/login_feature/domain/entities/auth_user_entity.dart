import 'package:equatable/equatable.dart';

/// The signed-in account, as summarized by the sign-in response.
class AuthUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? photo;
  final String language;

  /// `customer`, `staff`, `supplier` or `driver`.
  final String principalType;

  /// `pending`, `active` or `suspended`.
  final String state;

  const AuthUserEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.language,
    required this.principalType,
    required this.state,
    this.email,
    this.photo,
  });

  @override
  List<Object?> get props =>
      [id, fullName, phone, email, photo, language, principalType, state];
}
