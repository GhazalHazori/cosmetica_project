import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/logout_use_case.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._logoutUseCase) : super(const LogoutState.initial());

  final LogoutUseCase _logoutUseCase;

  Future<void> logout() async {
    emit(const LogoutState(status: LogoutStatus.loading));

    final result = await _logoutUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        LogoutState(
          status: LogoutStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const LogoutState(status: LogoutStatus.success)),
    );
  }
}
