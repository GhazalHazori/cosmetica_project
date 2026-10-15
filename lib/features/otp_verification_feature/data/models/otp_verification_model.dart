import '../../domain/entities/otp_verification_entity.dart';

/// Body of `POST /api/shop/auth/verify/`.
class OtpVerificationModel extends OtpVerificationEntity {
  const OtpVerificationModel({
    required super.phoneNumber,
    required super.otpCode,
  });

  factory OtpVerificationModel.fromEntity(OtpVerificationEntity entity) {
    return OtpVerificationModel(
      phoneNumber: entity.phoneNumber,
      otpCode: entity.otpCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phoneNumber,
      'code': otpCode,
    };
  }
}
