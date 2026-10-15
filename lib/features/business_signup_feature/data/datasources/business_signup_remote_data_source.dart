import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/business_signup_model.dart';

abstract class BusinessSignupRemoteDataSource {
  Future<void> businessSignup(BusinessSignupModel params);
}

class BusinessSignupRemoteDataSourceImpl
    implements BusinessSignupRemoteDataSource {
  BusinessSignupRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Creates a pending business account and sends a verification code.
  /// The account stays pending until staff review the commercial register.
  @override
  Future<void> businessSignup(BusinessSignupModel params) async {
    try {
      await _client.post(ApiConstants.register, data: await params.toFormData());
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
