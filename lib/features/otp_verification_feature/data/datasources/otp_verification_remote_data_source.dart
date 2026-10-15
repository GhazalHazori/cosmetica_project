import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/otp_verification_model.dart';

abstract class OtpVerificationRemoteDataSource {
  Future<void> verifyOtp(OtpVerificationModel params);
  Future<void> resendOtp(String phoneNumber);
}

class OtpVerificationRemoteDataSourceImpl
    implements OtpVerificationRemoteDataSource {
  OtpVerificationRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Activates an individual account; a business account stays pending
  /// until staff review it.
  @override
  Future<void> verifyOtp(OtpVerificationModel params) async {
    try {
      await _client.post(ApiConstants.verify, data: params.toJson());
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<void> resendOtp(String phoneNumber) async {
    try {
      await _client.post(ApiConstants.resendVerification, data: {'phone': phoneNumber});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
