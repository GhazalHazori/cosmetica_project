import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/signup_entity.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupCubit(this._signupUseCase) : super(const SignupState.initial());

  Future<void> signup(SignupEntity params) async {
    emit(const SignupState(status: SignupStatus.loading));

    final result = await _signupUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        failure is PhoneAlreadyRegisteredFailure
            ? SignupState(status: SignupStatus.phoneTaken, phone: params.phone)
            : SignupState(
                status: SignupStatus.failure,
                errorMessage: failure.message,
              ),
      ),
      (_) => emit(
        SignupState(status: SignupStatus.success, phone: params.phone),
      ),
    );
  }

  void reset() {
    emit(const SignupState.initial());
  }
}
