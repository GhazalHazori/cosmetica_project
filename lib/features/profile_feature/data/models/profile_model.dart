import '../../../../core/network/api_constants.dart';
import '../../domain/entities/profile_entity.dart';

/// Built from `Account` (`GET /api/auth/me/`).
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.phone,
    super.email,
    super.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      photoUrl: ApiConstants.resolveMediaUrl(json['photo'] as String?),
    );
  }
}
