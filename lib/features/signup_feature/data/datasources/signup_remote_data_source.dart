import '../models/signup_model.dart';

abstract class SignupRemoteDataSource {
  Future<void> signup(SignupModel params);
}

class SignupRemoteDataSourceImpl implements SignupRemoteDataSource {
  @override
  Future<void> signup(SignupModel params) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
