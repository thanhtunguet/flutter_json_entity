import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Extension on [DotEnv] to provide convenient access to environment variables.
extension SupaEnvironment on DotEnv {
  /// Gets the base API URL from the environment variables.
  ///
  /// **Returns:**
  /// - The base API URL as a string.
  String get baseApiUrl => env['BASE_API_URL']!;

  /// Gets the Sentry DSN from the environment variables.
  ///
  /// **Returns:**
  /// - The Sentry DSN as a string.
  String get sentryDsn => env['SENTRY_DSN']!;

  /// Gets the Azure AD tenant ID from the environment variables.
  ///
  /// **Returns:**
  /// - The Azure AD tenant ID as a string.
  String? get azureTenantId => env['AZURE_TENANT_ID'];

  /// Gets the Azure AD client ID from the environment variables.
  ///
  /// **Returns:**
  /// - The Azure AD client ID as a string.
  String? get azureClientId => env['AZURE_CLIENT_ID'];

  /// Gets the Azure AD client secret from the environment variables.
  ///
  /// **Returns:**
  /// - The Azure AD client secret as a string.
  String? get azureObjectId => env['AZURE_OBJECT_ID'];

  /// Gets the Azure AD redirect URI from the environment variables.
  ///
  /// **Returns:**
  /// - The Azure AD redirect URI as a string.
  String? get azureRedirectUri => env['AZURE_REDIRECT_URI'];

  /// Gets the Google reCAPTCHA site key from the environment variables.
  ///
  /// **Returns:**
  /// - The Google reCAPTCHA site key as a string.
  String? get googleRecaptchaAndroidKey => env['GOOGLE_RECAPTCHA_ANDROID_KEY'];

  /// Gets the Google reCAPTCHA site key from the environment variables.
  ///
  /// **Returns:**
  /// - The Google reCAPTCHA site key as a string.
  String? get googleRecaptchaIosKey => env['GOOGLE_RECAPTCHA_IOS_KEY'];
}
