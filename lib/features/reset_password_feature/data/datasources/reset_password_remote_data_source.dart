import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/new_password_model.dart';
import '../models/reset_code_model.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<void> requestCode(String phone);
  Future<void> verifyCode(ResetCodeModel params);
  Future<void> completeReset(NewPasswordModel params);
}

class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  ResetPasswordRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Answers the same whether or not the number has an account.
  @override
  Future<void> requestCode(String phone) {
    return _post(ApiConstants.passwordResetRequest, {'phone': phone});
  }

  /// 400 when the code is wrong, expired or exhausted.
  @override
  Future<void> verifyCode(ResetCodeModel params) {
    return _post(ApiConstants.passwordResetVerify, params.toJson());
  }

  /// Spends the verified code; ends every session issued before it.
  @override
  Future<void> completeReset(NewPasswordModel params) {
    return _post(ApiConstants.passwordResetComplete, params.toJson());
  }

  Future<void> _post(String path, Map<String, dynamic> data) async {
    try {
      await _client.post(path, data: data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
