import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState.initial());

  Future<void> login(String identifier, String password) async {
    emit(const LoginState(status: LoginStatus.loading));

    final result = await _loginUseCase(
      LoginEntity(
        identifier: identifier,
        password: password,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        LoginState(
          status: failure is AccountPendingFailure
              ? LoginStatus.accountPending
              : LoginStatus.failure,
          errorMessage: failure.message,
          identifier: identifier,
        ),
      ),
      (user) => emit(LoginState(status: LoginStatus.success, user: user)),
    );
  }

  void reset() {
    emit(const LoginState.initial());
  }
}
