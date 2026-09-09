import '../../domain/entities/otp_verification_entity.dart';

class OtpVerificationModel extends OtpVerificationEntity {
  const OtpVerificationModel({
    required super.phoneNumber,
    required super.otpCode,
  });

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationModel(
      phoneNumber: json['phoneNumber'] as String,
      otpCode: json['otpCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otpCode': otpCode,
    };
  }
}
