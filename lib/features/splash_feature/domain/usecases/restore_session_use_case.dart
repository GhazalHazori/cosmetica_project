import '../repositories/session_repository.dart';

class RestoreSessionUseCase {
  RestoreSessionUseCase(this._repository);

  final SessionRepository _repository;

  Future<bool> call() {
    return _repository.restoreSession();
  }
}
