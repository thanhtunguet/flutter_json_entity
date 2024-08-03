import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Extension on [DotEnv] to provide convenient access to environment variables.
extension SupaDotEnv on DotEnv {
  /// Gets the base API URL from the environment variables.
  ///
  /// **Returns:**
  /// - The base API URL as a string.
  String get baseApiUrl => env['BASE_API_URL']!;

  /// Gets the Sentry DSN (Data Source Name) from the environment variables.
  ///
  /// **Returns:**
  /// - The Sentry DSN as a string.
  String get sentryDsn => env['SENTRY_DSN']!;
}
