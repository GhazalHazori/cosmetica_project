import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/account_info_entity.dart';
import '../../domain/usecases/account_info_usecases.dart';

part 'account_info_state.dart';

class AccountInfoCubit extends Cubit<AccountInfoState> {
  final GetAccountInfoUseCase _getAccountInfoUseCase;
  final UpdateAccountInfoUseCase _updateAccountInfoUseCase;
  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;

  AccountInfoCubit(
    this._getAccountInfoUseCase,
    this._updateAccountInfoUseCase,
    this._updateProfilePhotoUseCase,
  ) : super(const AccountInfoState.initial()) {
    loadAccountInfo();
  }

  Future<void> loadAccountInfo() {
    return _run(_getAccountInfoUseCase.call, AccountInfoStatus.loaded);
  }

  Future<void> saveChanges({
    required String fullName,
    required String email,
  }) async {
    final current = state.accountInfo;
    if (current == null) return;
    return _run(
      () => _updateAccountInfoUseCase(
        current: current,
        fullName: fullName,
        email: email,
      ),
      AccountInfoStatus.saved,
    );
  }

  Future<void> updatePhoto(String photoPath) {
    return _run(
      () => _updateProfilePhotoUseCase(photoPath),
      AccountInfoStatus.photoUpdated,
    );
  }

  Future<void> _run(
    Future<Either<Failure, AccountInfoEntity>> Function() call,
    AccountInfoStatus onSuccess,
  ) async {
    emit(state.copyWith(status: AccountInfoStatus.loading));

    final result = await call();

    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountInfoStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (accountInfo) => emit(
        state.copyWith(status: onSuccess, accountInfo: accountInfo),
      ),
    );
  }
}
