part of "error_handling_bloc.dart";

/// Abstract base class for all error handling states.
abstract class ErrorHandlingState {}

/// Abstract base class for all error handling events.
class ErrorHandlingInitial extends ErrorHandlingState {}

/// Abstract base class for all error handling states.
class ErrorHandlingInitialized extends ErrorHandlingState {}

/// Abstract base class for all error handling states.
class ErrorCaptured extends ErrorHandlingState {
  /// The captured error.
  final dynamic error;

  /// Creates an instance of [ErrorCaptured].
  ErrorCaptured(this.error);
}

/// Abstract base class for all error handling states.
class ErrorHandlingFailed extends ErrorHandlingState {
  /// The error message.
  final String errorMessage;

  /// Creates an instance of [ErrorHandlingFailed].
  ErrorHandlingFailed(this.errorMessage);
}
