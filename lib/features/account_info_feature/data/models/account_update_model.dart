import 'package:dio/dio.dart';

import '../../domain/entities/account_update_entity.dart';

/// Body of `PATCH /api/auth/me/`: JSON, or multipart when a photo is sent.
class AccountUpdateModel extends AccountUpdateEntity {
  const AccountUpdateModel({super.fullName, super.email, super.photoPath});

  factory AccountUpdateModel.fromEntity(AccountUpdateEntity entity) {
    return AccountUpdateModel(
      fullName: entity.fullName,
      email: entity.email,
      photoPath: entity.photoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
    };
  }

  Future<Object> toRequestData() async {
    final path = photoPath;
    if (path == null) return toJson();
    return FormData.fromMap({
      ...toJson(),
      'photo': await MultipartFile.fromFile(path),
    });
  }
}
