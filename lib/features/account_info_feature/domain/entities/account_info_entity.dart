import 'package:equatable/equatable.dart';

/// The signed-in account, as returned by `GET /api/auth/me/`.
class AccountInfoEntity extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? photoUrl;
  final String initials;

  const AccountInfoEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.initials,
    this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, fullName, phone, email, photoUrl, initials];
}
