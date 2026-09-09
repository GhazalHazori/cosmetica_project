import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/login_entity.dart';
import '../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginState.initial());

  Future<void> login(String identifier, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginUseCase(
      LoginEntity(
        identifier: identifier,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const LoginState(status: LoginStatus.success)),
    );
  }

  void reset() {
    emit(const LoginState.initial());
  }
}
