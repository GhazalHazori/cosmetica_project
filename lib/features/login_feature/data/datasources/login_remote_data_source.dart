import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_model.dart';

abstract class LoginRemoteDataSource {
  Future<void> login(LoginModel params);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl()
      : _client = ApiClient(baseUrl: 'https://example.com/api');

  final ApiClient _client;

  @override
  Future<void> login(LoginModel params) async {
    try {
      await _client.post('/login', data: params.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
