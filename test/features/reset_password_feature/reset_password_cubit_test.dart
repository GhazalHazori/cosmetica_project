import 'package:cosmetica_project/core/error/failures.dart';
import 'package:cosmetica_project/features/reset_password_feature/domain/entities/new_password_entity.dart';
import 'package:cosmetica_project/features/reset_password_feature/domain/entities/reset_code_entity.dart';
import 'package:cosmetica_project/features/reset_password_feature/domain/repositories/reset_password_repository.dart';
import 'package:cosmetica_project/features/reset_password_feature/domain/usecases/reset_password_usecases.dart';
import 'package:cosmetica_project/features/reset_password_feature/presentation/cubit/reset_password_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements ResetPasswordRepository {
  final List<Object> calls = [];
  Failure? verifyFailure;

  @override
  Future<Either<Failure, void>> requestCode(String phone) async {
    calls.add(phone);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> verifyCode(ResetCodeEntity params) async {
    calls.add(params);
    final failure = verifyFailure;
    return failure == null ? const Right(null) : Left(failure);
  }

  @override
  Future<Either<Failure, void>> completeReset(NewPasswordEntity params) async {
    calls.add(params);
    return const Right(null);
  }
}

void main() {
  late _FakeRepository repository;
  late ResetPasswordCubit cubit;

  setUp(() {
    repository = _FakeRepository();
    cubit = ResetPasswordCubit(
      RequestResetCodeUseCase(repository),
      VerifyResetCodeUseCase(repository),
      CompleteResetPasswordUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  test('runs phone → code → new password with the same phone', () async {
    await cubit.requestCode('+963944000104');
    expect(cubit.state.step, ResetPasswordStep.code);
    expect(cubit.state.status, ResetPasswordStatus.codeSent);

    await cubit.verifyCode('123456');
    expect(cubit.state.step, ResetPasswordStep.newPassword);
    final verified = repository.calls[1] as ResetCodeEntity;
    expect(verified.phone, '+963944000104');
    expect(verified.code, '123456');

    await cubit.completeReset('NewPass123');
    expect(cubit.state.status, ResetPasswordStatus.completed);
    final completed = repository.calls[2] as NewPasswordEntity;
    expect(completed.phone, '+963944000104');
    expect(completed.newPassword, 'NewPass123');
  });

  test('a wrong code stays on the code step with the server message',
      () async {
    repository.verifyFailure = const ServerFailure('That code is not correct.');
    await cubit.requestCode('+963944000104');

    await cubit.verifyCode('000000');

    expect(cubit.state.step, ResetPasswordStep.code);
    expect(cubit.state.status, ResetPasswordStatus.failure);
    expect(cubit.state.errorMessage, 'That code is not correct.');
  });

  test('resend asks for a code for the stored phone again', () async {
    await cubit.requestCode('+963944000104');
    await cubit.resendCode();

    expect(repository.calls, ['+963944000104', '+963944000104']);
    expect(cubit.state.status, ResetPasswordStatus.codeSent);
  });

  test('back walks the steps and reports the first step', () async {
    await cubit.requestCode('+963944000104');
    await cubit.verifyCode('123456');

    expect(cubit.back(), isTrue);
    expect(cubit.state.step, ResetPasswordStep.code);
    expect(cubit.back(), isTrue);
    expect(cubit.state.step, ResetPasswordStep.phone);
    expect(cubit.back(), isFalse);
  });
}
