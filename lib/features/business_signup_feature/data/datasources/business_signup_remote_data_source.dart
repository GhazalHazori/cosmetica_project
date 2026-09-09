import '../models/business_signup_model.dart';

abstract class BusinessSignupRemoteDataSource {
  Future<void> businessSignup(BusinessSignupModel params);
}

class BusinessSignupRemoteDataSourceImpl implements BusinessSignupRemoteDataSource {
  @override
  Future<void> businessSignup(BusinessSignupModel params) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
