part of 'account_info_cubit.dart';

/// [loaded]: account fetched. [saved]: name / email saved.
/// [photoUpdated]: new photo uploaded.
enum AccountInfoStatus {
  initial,
  loading,
  loaded,
  saved,
  photoUpdated,
  failure,
}

class AccountInfoState extends Equatable {
  final AccountInfoStatus status;
  final AccountInfoEntity? accountInfo;
  final String? errorMessage;

  const AccountInfoState({
    required this.status,
    this.accountInfo,
    this.errorMessage,
  });

  const AccountInfoState.initial()
      : status = AccountInfoStatus.initial,
        accountInfo = null,
        errorMessage = null;

  /// [errorMessage] is cleared unless given.
  AccountInfoState copyWith({
    AccountInfoStatus? status,
    AccountInfoEntity? accountInfo,
    String? errorMessage,
  }) {
    return AccountInfoState(
      status: status ?? this.status,
      accountInfo: accountInfo ?? this.accountInfo,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accountInfo, errorMessage];
}
