import '../../domain/entities/reset_code_entity.dart';

/// Body of `POST /api/auth/password/reset/verify/`.
class ResetCodeModel extends ResetCodeEntity {
  const ResetCodeModel({
    required super.phone,
    required super.code,
  });

  factory ResetCodeModel.fromEntity(ResetCodeEntity entity) {
    return ResetCodeModel(phone: entity.phone, code: entity.code);
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }
}
