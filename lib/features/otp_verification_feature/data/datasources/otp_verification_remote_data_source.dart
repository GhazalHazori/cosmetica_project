import '../models/otp_verification_model.dart';

abstract class OtpVerificationRemoteDataSource {
  Future<void> verifyOtp(OtpVerificationModel params);
  Future<void> resendOtp(String phoneNumber);
}

class OtpVerificationRemoteDataSourceImpl implements OtpVerificationRemoteDataSource {
  @override
  Future<void> verifyOtp(OtpVerificationModel params) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
