import 'package:equatable/equatable.dart';

/// What the profile header shows about the signed-in account.
class ProfileEntity extends Equatable {
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;

  const ProfileEntity({
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
  });

  /// The email, or the phone number when the account has none.
  String get contact {
    final email = this.email;
    return email == null || email.isEmpty ? phone : email;
  }

  @override
  List<Object?> get props => [name, phone, email, photoUrl];
}
