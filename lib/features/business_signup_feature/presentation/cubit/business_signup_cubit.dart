import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/business_signup_entity.dart';
import '../../domain/usecases/business_signup_use_case.dart';

part 'business_signup_state.dart';

class BusinessSignupCubit extends Cubit<BusinessSignupState> {
  final BusinessSignupUseCase _businessSignupUseCase;

  BusinessSignupCubit(this._businessSignupUseCase) : super(const BusinessSignupState.initial());

  Future<void> businessSignup(BusinessSignupEntity params) async {
    emit(state.copyWith(status: BusinessSignupStatus.loading));

    final result = await _businessSignupUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BusinessSignupStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(const BusinessSignupState(status: BusinessSignupStatus.success)),
    );
  }

  void reset() {
    emit(const BusinessSignupState.initial());
  }
}
