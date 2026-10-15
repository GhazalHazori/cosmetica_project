import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required LoginRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  final LoginRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params) async {
    try {
      final result =
          await _remoteDataSource.login(LoginModel.fromEntity(params));
      await _tokenStorage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      return Right(result.account);
    } on ServerException catch (e) {
      if (_isAccountPending(e)) return Left(AccountPendingFailure(e.message));
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ParsingFailure(e.toString()));
    }
  }

  /// Codes that mean the credentials themselves were refused (or the client
  /// was throttled), not the account's state.
  static const Set<String> _credentialCodes = {
    'authentication_failed',
    'not_authenticated',
    'throttled',
  };

  static const List<String> _suspendedWords = ['suspend', 'موقوف', 'معطل'];

  static const List<String> _pendingWords = [
    'pending',
    'verif',
    'inactive',
    'not_active',
    'not active',
    'تحقق',
    'تأكيد',
    'تفعيل',
    'مفعل',
    'بانتظار',
  ];

  /// Per the API, wrong credentials always come back as
  /// `authentication_failed`, while a pending or suspended account is refused
  /// with a distinguishable reason. So any other refused sign-in is about the
  /// account's state: pending unless it says suspended. The message is
  /// localized (Arabic by default), so wording is only a fallback for a
  /// response without a code.
  static bool _isAccountPending(ServerException e) {
    if (e.statusCode != 401 && e.statusCode != 403) return false;

    final reason = '${e.code ?? ''} ${e.message}'.toLowerCase();
    if (_suspendedWords.any(reason.contains)) return false;

    final code = e.code;
    if (code != null && code.isNotEmpty) {
      return !_credentialCodes.contains(code);
    }
    return _pendingWords.any(reason.contains);
  }
}
