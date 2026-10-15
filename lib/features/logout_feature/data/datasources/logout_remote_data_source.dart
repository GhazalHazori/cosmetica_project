import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';

abstract class LogoutRemoteDataSource {
  Future<void> signOut(String refreshToken);
}

class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  LogoutRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  /// Revokes [refreshToken]; 401 when it is already not valid.
  @override
  Future<void> signOut(String refreshToken) async {
    try {
      await _client.post(ApiConstants.signOut, data: {'refresh': refreshToken});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
