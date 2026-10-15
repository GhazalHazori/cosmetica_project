/// Base failure type for all domain-level errors.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(String message) : super(message);
}



/// Registration refused because the mobile number already has an account
/// (verified or still awaiting its code — the API does not say which).
class PhoneAlreadyRegisteredFailure extends Failure {
  const PhoneAlreadyRegisteredFailure(String message) : super(message);
}

/// Sign-in refused because the account is still pending: its number is not
/// verified yet, or a business account awaits staff review.
class AccountPendingFailure extends Failure {
  const AccountPendingFailure(String message) : super(message);
}
