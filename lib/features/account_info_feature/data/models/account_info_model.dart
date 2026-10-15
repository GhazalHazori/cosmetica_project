import '../../../../core/network/api_constants.dart';
import '../../domain/entities/account_info_entity.dart';

/// `Account` from `GET` / `PATCH /api/auth/me/`.
class AccountInfoModel extends AccountInfoEntity {
  const AccountInfoModel({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.initials,
    super.email,
    super.photoUrl,
  });

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) {
    return AccountInfoModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      initials: json['initials'] as String? ?? '',
      email: json['email'] as String?,
      photoUrl: ApiConstants.resolveMediaUrl(json['photo'] as String?),
    );
  }
}
