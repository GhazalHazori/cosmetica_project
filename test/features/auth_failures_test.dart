import 'package:cosmetica_project/core/error/exceptions.dart';
import 'package:cosmetica_project/core/error/failures.dart';
import 'package:cosmetica_project/core/network/token_storage.dart';
import 'package:cosmetica_project/features/login_feature/data/datasources/login_remote_data_source.dart';
import 'package:cosmetica_project/features/login_feature/data/models/login_model.dart';
import 'package:cosmetica_project/features/login_feature/data/models/sign_in_response_model.dart';
import 'package:cosmetica_project/features/login_feature/data/repositories/login_repository_impl.dart';
import 'package:cosmetica_project/features/login_feature/domain/entities/login_entity.dart';
import 'package:cosmetica_project/features/signup_feature/data/datasources/signup_remote_data_source.dart';
import 'package:cosmetica_project/features/signup_feature/data/models/signup_model.dart';
import 'package:cosmetica_project/features/signup_feature/data/repositories/signup_repository_impl.dart';
import 'package:cosmetica_project/features/signup_feature/domain/entities/signup_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_network.dart';

class _FailingLogin implements LoginRemoteDataSource {
  _FailingLogin(this.error);
  final ServerException error;

  @override
  Future<SignInResponseModel> login(LoginModel params) => throw error;
}

class _FailingSignup implements SignupRemoteDataSource {
  _FailingSignup(this.error);
  final ServerException error;

  @override
  Future<void> signup(SignupModel params) => throw error;
}

Future<Failure> _loginFailure(ServerException error) async {
  final TokenStorage storage = MemoryTokenStorage();
  final result = await LoginRepositoryImpl(
    remoteDataSource: _FailingLogin(error),
    tokenStorage: storage,
  ).login(const LoginEntity(identifier: '+963944000104', password: 'x'));
  return result.fold((f) => f, (_) => throw StateError('expected a failure'));
}

void main() {
  group('sign-in', () {
    test('a pending account is recognised', () async {
      final failure = await _loginFailure(
        ServerException(
          'This account is pending.',
          statusCode: 401,
          code: 'account_pending',
        ),
      );
      expect(failure, isA<AccountPendingFailure>());
    });

    test('any other refusal code with an Arabic message is pending', () async {
      final failure = await _loginFailure(
        ServerException(
          'هذا الحساب بانتظار التحقق من رقم الهاتف.',
          statusCode: 401,
          code: 'account_not_active',
        ),
      );
      expect(failure, isA<AccountPendingFailure>());
    });

    test('a 403 refusal of the account is pending too', () async {
      final failure = await _loginFailure(
        ServerException('Verify your number.', statusCode: 403, code: 'x'),
      );
      expect(failure, isA<AccountPendingFailure>());
    });

    test('without a code, Arabic wording about verification is pending',
        () async {
      final failure = await _loginFailure(
        ServerException('يجب تأكيد رقم الهاتف أولاً.', statusCode: 401),
      );
      expect(failure, isA<AccountPendingFailure>());
    });

    test('a suspended account in Arabic is not pending', () async {
      final failure = await _loginFailure(
        ServerException(
          'هذا الحساب موقوف.',
          statusCode: 401,
          code: 'account_state',
        ),
      );
      expect(failure, isA<ServerFailure>());
    });

    test('wrong credentials stay an ordinary failure', () async {
      final failure = await _loginFailure(
        ServerException(
          'Those credentials are not correct.',
          statusCode: 401,
          code: 'authentication_failed',
        ),
      );
      expect(failure, isA<ServerFailure>());
    });

    test('a suspended account is not treated as pending', () async {
      final failure = await _loginFailure(
        ServerException(
          'This account is suspended.',
          statusCode: 401,
          code: 'account_suspended',
        ),
      );
      expect(failure, isA<ServerFailure>());
    });
  });

  test('registering a taken number gives PhoneAlreadyRegisteredFailure',
      () async {
    final result = await SignupRepositoryImpl(
      remoteDataSource: _FailingSignup(
        ServerException('That mobile number cannot be used.', statusCode: 409),
      ),
    ).signup(
      const SignupEntity(
        fullName: 'Lina',
        phone: '+963944000104',
        password: 'Secret123',
      ),
    );

    expect(
      result.fold((f) => f, (_) => null),
      isA<PhoneAlreadyRegisteredFailure>(),
    );
  });
}
