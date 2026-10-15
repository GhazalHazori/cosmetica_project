import 'package:cosmetica_project/features/otp_verification_feature/data/datasources/otp_verification_remote_data_source.dart';
import 'package:cosmetica_project/features/otp_verification_feature/data/datasources/pending_verification_local_data_source.dart';
import 'package:cosmetica_project/features/otp_verification_feature/data/models/otp_verification_model.dart';
import 'package:cosmetica_project/features/otp_verification_feature/data/repositories/otp_verification_repository_impl.dart';
import 'package:cosmetica_project/features/otp_verification_feature/domain/entities/otp_verification_entity.dart';
import 'package:cosmetica_project/features/otp_verification_feature/domain/entities/pending_verification_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRemote implements OtpVerificationRemoteDataSource {
  @override
  Future<void> verifyOtp(OtpVerificationModel params) async {}

  @override
  Future<void> resendOtp(String phoneNumber) async {}
}

void main() {
  late SharedPreferences prefs;
  late OtpVerificationRepositoryImpl repository;

  final pending = PendingVerificationEntity(
    phoneNumber: '+963944000104',
    isBusiness: true,
    // Long ago, so any resend is after it.
    codeSentAt: DateTime(2020, 1, 1, 10),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = OtpVerificationRepositoryImpl(
      remoteDataSource: _FakeRemote(),
      localDataSource: PendingVerificationLocalDataSourceImpl(prefs),
    );
  });

  test('a saved verification survives and reads back intact', () async {
    await repository.savePendingVerification(pending);

    final restored = repository.getPendingVerification()!;
    expect(restored.phoneNumber, pending.phoneNumber);
    expect(restored.isBusiness, pending.isBusiness);
    expect(restored.codeSentAt, pending.codeSentAt);
  });

  test('verifying the code clears the pending verification', () async {
    await repository.savePendingVerification(pending);

    await repository.verifyOtp(
      const OtpVerificationEntity(
        phoneNumber: '+963944000104',
        otpCode: '123456',
      ),
    );

    expect(repository.getPendingVerification(), isNull);
  });

  test('resending restarts the code time, keeping the account type', () async {
    await repository.savePendingVerification(pending);

    await repository.resendOtp('+963944000104');

    final updated = repository.getPendingVerification()!;
    expect(updated.isBusiness, isTrue);
    expect(updated.codeSentAt.isAfter(pending.codeSentAt), isTrue);
  });

  test('abandoning clears it', () async {
    await repository.savePendingVerification(pending);

    await repository.clearPendingVerification();

    expect(repository.getPendingVerification(), isNull);
  });

  test('unreadable stored data is dropped instead of crashing', () async {
    await prefs.setString('otp.pending_verification', '{not json');

    expect(repository.getPendingVerification(), isNull);
    expect(prefs.getString('otp.pending_verification'), isNull);
  });
}
