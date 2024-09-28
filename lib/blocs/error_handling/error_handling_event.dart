part of 'error_handling_bloc.dart';

/// Abstract base class for all error handling events.
abstract class ErrorHandlingEvent {}

/// Event triggered when the application is initialized.
class InitializeErrorHandling extends ErrorHandlingEvent {}

/// Event triggered when an exception is captured.
class CaptureException extends ErrorHandlingEvent {
  /// The exception or error to be logged. Only logs instances of [Error] type.
  final dynamic error;

  /// Constructs a [CaptureException] event with the given [error].
  CaptureException(this.error);
}
