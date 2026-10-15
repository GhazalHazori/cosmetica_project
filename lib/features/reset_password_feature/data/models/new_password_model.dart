import '../../domain/entities/new_password_entity.dart';

/// Body of `POST /api/auth/password/reset/complete/`.
class NewPasswordModel extends NewPasswordEntity {
  const NewPasswordModel({
    required super.phone,
    required super.newPassword,
  });

  factory NewPasswordModel.fromEntity(NewPasswordEntity entity) {
    return NewPasswordModel(
      phone: entity.phone,
      newPassword: entity.newPassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'new_password': newPassword,
    };
  }
}
