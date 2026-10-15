import 'package:dio/dio.dart';

import '../../domain/entities/business_signup_entity.dart';

/// Body of `POST /api/shop/auth/register/` for a business account.
///
/// Sent as `multipart/form-data` because it carries the commercial register.
class BusinessSignupModel extends BusinessSignupEntity {
  const BusinessSignupModel({
    required super.fullName,
    required super.phone,
    required super.password,
    required super.commercialRegisterFilePath,
    super.email,
    super.language,
  });

  factory BusinessSignupModel.fromEntity(BusinessSignupEntity entity) {
    return BusinessSignupModel(
      fullName: entity.fullName,
      phone: entity.phone,
      password: entity.password,
      commercialRegisterFilePath: entity.commercialRegisterFilePath,
      email: entity.email,
      language: entity.language,
    );
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'full_name': fullName,
      'phone': phone,
      'password': password,
      if (email != null && email!.isNotEmpty) 'email': email,
      'language': language,
      'is_business': 'true',
      'commercial_register_document':
          await MultipartFile.fromFile(commercialRegisterFilePath),
    });
  }
}
