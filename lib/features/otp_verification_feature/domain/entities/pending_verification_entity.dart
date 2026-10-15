import 'package:equatable/equatable.dart';

/// A registration whose mobile number has not been verified yet, kept on the
/// device so the user can resume it after leaving the app.
class PendingVerificationEntity extends Equatable {
  final String phoneNumber;
  final bool isBusiness;

  /// When the last code was sent; its validity window starts here.
  final DateTime codeSentAt;

  const PendingVerificationEntity({
    required this.phoneNumber,
    required this.isBusiness,
    required this.codeSentAt,
  });

  @override
  List<Object?> get props => [phoneNumber, isBusiness, codeSentAt];
}
