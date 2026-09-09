import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/signup_entity.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupCubit(this._signupUseCase) : super(const SignupState.initial());

  Future<void> signup(SignupEntity params) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _signupUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const SignupState(status: SignupStatus.success)),
    );
  }

  void reset() {
    emit(const SignupState.initial());
  }
}
