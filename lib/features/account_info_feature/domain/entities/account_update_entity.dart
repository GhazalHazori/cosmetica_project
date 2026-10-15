import 'package:equatable/equatable.dart';

/// Changes to send with `PATCH /api/auth/me/`; `null` fields are left as they
/// are on the server.
///
/// The phone number is not editable here: changing it clears its
/// verification, which needs its own code flow.
class AccountUpdateEntity extends Equatable {
  final String? fullName;

  /// An empty string removes the email address.
  final String? email;

  /// Local path of a new profile photo.
  final String? photoPath;

  const AccountUpdateEntity({this.fullName, this.email, this.photoPath});

  bool get isEmpty => fullName == null && email == null && photoPath == null;

  @override
  List<Object?> get props => [fullName, email, photoPath];
}
