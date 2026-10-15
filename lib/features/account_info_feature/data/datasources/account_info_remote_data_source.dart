import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_error_mapper.dart';
import '../models/account_info_model.dart';
import '../models/account_update_model.dart';

abstract class AccountInfoRemoteDataSource {
  Future<AccountInfoModel> getAccountInfo();
  Future<AccountInfoModel> updateAccountInfo(AccountUpdateModel update);
}

class AccountInfoRemoteDataSourceImpl implements AccountInfoRemoteDataSource {
  AccountInfoRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<AccountInfoModel> getAccountInfo() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(ApiConstants.me);
      return AccountInfoModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<AccountInfoModel> updateAccountInfo(AccountUpdateModel update) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        ApiConstants.me,
        data: await update.toRequestData(),
      );
      return AccountInfoModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
