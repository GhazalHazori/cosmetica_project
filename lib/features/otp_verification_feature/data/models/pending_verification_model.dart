import '../../domain/entities/pending_verification_entity.dart';

class PendingVerificationModel extends PendingVerificationEntity {
  const PendingVerificationModel({
    required super.phoneNumber,
    required super.isBusiness,
    required super.codeSentAt,
  });

  factory PendingVerificationModel.fromEntity(PendingVerificationEntity e) {
    return PendingVerificationModel(
      phoneNumber: e.phoneNumber,
      isBusiness: e.isBusiness,
      codeSentAt: e.codeSentAt,
    );
  }

  factory PendingVerificationModel.fromJson(Map<String, dynamic> json) {
    return PendingVerificationModel(
      phoneNumber: json['phone'] as String,
      isBusiness: json['is_business'] as bool,
      codeSentAt: DateTime.fromMillisecondsSinceEpoch(
        json['code_sent_at'] as int,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phoneNumber,
      'is_business': isBusiness,
      'code_sent_at': codeSentAt.millisecondsSinceEpoch,
    };
  }
}
