import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/login_model.dart';
import '../models/sign_in_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<SignInResponseModel> login(LoginModel params);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Customers sign in with their mobile number or email address.
  @override
  Future<SignInResponseModel> login(LoginModel params) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiConstants.signIn,
        data: params.toJson(),
      );
      return SignInResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
