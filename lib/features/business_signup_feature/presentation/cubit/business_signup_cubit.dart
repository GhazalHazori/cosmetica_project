import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/business_signup_entity.dart';
import '../../domain/usecases/business_signup_use_case.dart';

part 'business_signup_state.dart';

class BusinessSignupCubit extends Cubit<BusinessSignupState> {
  final BusinessSignupUseCase _businessSignupUseCase;

  BusinessSignupCubit(this._businessSignupUseCase)
      : super(const BusinessSignupState.initial());

  Future<void> businessSignup(BusinessSignupEntity params) async {
    emit(const BusinessSignupState(status: BusinessSignupStatus.loading));

    final result = await _businessSignupUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        failure is PhoneAlreadyRegisteredFailure
            ? BusinessSignupState(
                status: BusinessSignupStatus.phoneTaken,
                phone: params.phone,
              )
            : BusinessSignupState(
                status: BusinessSignupStatus.failure,
                errorMessage: failure.message,
              ),
      ),
      (_) => emit(
        BusinessSignupState(
          status: BusinessSignupStatus.success,
          phone: params.phone,
        ),
      ),
    );
  }

  void reset() {
    emit(const BusinessSignupState.initial());
  }
}
