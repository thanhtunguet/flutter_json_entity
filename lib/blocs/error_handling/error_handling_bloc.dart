import "package:bloc/bloc.dart";
import "package:dio/dio.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:sentry_flutter/sentry_flutter.dart";
import "package:supa_architecture/supa_architecture.dart";

part "error_handling_event.dart";
part "error_handling_state.dart";

/// Bloc that handles error capturing and reporting to Firebase Crashlytics and Sentry.
class ErrorHandlingBloc extends Cubit<void> {
  /// Constructor for the error handling bloc.
  ErrorHandlingBloc() : super(null);

  /// Initializes the error handling mechanisms by setting up Crashlytics
  /// and Sentry for capturing uncaught errors and exceptions.
  ///
  /// This method configures:
  /// - [FlutterError.onError] to capture uncaught Flutter framework errors and send them to Firebase Crashlytics.
  /// - [PlatformDispatcher.onError] to capture platform-related errors, such as native crashes, and send them to Firebase Crashlytics.
  void initialize() {
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      if (SupaApplication.instance.useFirebase) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }
    };

    // Pass all platform dispatcher errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      if (SupaApplication.instance.useFirebase) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
  }

  /// Captures and logs exceptions to Firebase Crashlytics and Sentry.
  ///
  /// This method checks the platform (Android, iOS) and logs the error to Firebase Crashlytics
  /// if it is supported. Additionally, the error is reported to Sentry regardless of the platform.
  ///
  /// - [error]: The exception or error to be logged. Only logs instances of [Error] type.
  void captureException(dynamic error) {
    if (error is Error) {
      // Log to Firebase Crashlytics on supported platforms (Android, iOS)
      if (!kIsWeb && SupaApplication.instance.useFirebase) {
        FirebaseCrashlytics.instance.recordError(error, error.stackTrace);
      }
      // Log to Sentry for web and all other platforms
      Sentry.captureException(error);
      return;
    }
    if (error is DioException) {
      Sentry.captureException(error);
      return;
    }
  }
}
