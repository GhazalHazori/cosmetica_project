import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/repositories/logout_repository.dart';
import '../datasources/logout_remote_data_source.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  LogoutRepositoryImpl({
    required LogoutRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  final LogoutRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<Either<Failure, void>> logout() async {
    final refreshToken = _tokenStorage.refreshToken;
    try {
      if (refreshToken != null) {
        await _remoteDataSource.signOut(refreshToken);
      }
    } on ServerException catch (e) {
      // 401: the token is already revoked or expired, so the session is over
      // either way. Anything else keeps the user signed in to retry.
      if (e.statusCode != 401) return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ParsingFailure(e.toString()));
    }

    await _tokenStorage.clear();
    return const Right(null);
  }
}
