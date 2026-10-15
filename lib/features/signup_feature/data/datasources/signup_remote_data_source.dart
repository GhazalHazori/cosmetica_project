import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/signup_model.dart';

abstract class SignupRemoteDataSource {
  Future<void> signup(SignupModel params);
}

class SignupRemoteDataSourceImpl implements SignupRemoteDataSource {
  SignupRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Creates a pending account and sends a verification code to the phone.
  @override
  Future<void> signup(SignupModel params) async {
    try {
      await _client.post(ApiConstants.register, data: params.toJson());
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
