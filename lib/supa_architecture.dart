library supa_architecture;

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/config/get_it.dart';
import 'package:supa_architecture/data/data.dart';
import 'package:supa_architecture/services/cookie_storage_service.dart';
import 'package:supa_architecture/services/persistent_storage_service.dart';
import 'package:supa_architecture/services/secure_storage_service.dart';

export 'api_client/api_client.dart';
export 'blocs/blocs.dart';
export 'constants/constants.dart';
export 'data/data.dart';
export 'exceptions/exceptions.dart';
export 'extensions/extensions.dart';
export 'filters/filters.dart';
export 'json/json.dart';
export 'providers/providers.dart';
export 'repositories/base_repository.dart';
export 'widgets/widgets.dart';

/// The main class for the Supa Architecture package.
///
/// This class provides initialization and configuration methods for various
/// services and settings within the Supa Architecture package.
class SupaApplication {
  /// Singleton instance of [SupaApplication].
  static late final SupaApplication instance;

  static bool _isInitialized = false;

  /// Service for managing cookies.
  final CookieStorageService cookieStorageService;

  /// Service for managing secure storage.
  final SecureStorageService secureStorageService;

  /// Service for managing persistent storage.
  final PersistentStorageService persistentStorageService;

  /// Information about the device.
  final DeviceInfo deviceInfo;

  RecaptchaConfig? _captchaConfig;

  /// Private constructor for creating an instance of [SupaApplication].
  SupaApplication._({
    required this.cookieStorageService,
    required this.secureStorageService,
    required this.persistentStorageService,
    required this.deviceInfo,
  });

  /// Getter for the reCAPTCHA configuration.
  ///
  /// **Returns:**
  /// - The reCAPTCHA configuration.
  RecaptchaConfig get captchaConfig => _captchaConfig!;

  /// Checks if reCAPTCHA is enabled.
  ///
  /// **Returns:**
  /// - `true` if reCAPTCHA is enabled, `false` otherwise.
  bool get useCaptcha => _captchaConfig != null;

  /// Initializes the [SupaApplication].
  ///
  /// This method loads environment variables, initializes services, and registers models.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the singleton instance of [SupaApplication].
  static Future<SupaApplication> initialize() async {
    if (!_isInitialized) {
      try {
        await dotenv.load();

        final cookieStorageService = await CookieStorageService.initialize();

        final persistentStorageService =
            await PersistentStorageService.initialize();

        final secureStorageService = SecureStorageService.initialize();

        final deviceInfo = await DeviceInfo.getDeviceInfo();

        instance = SupaApplication._(
          cookieStorageService: cookieStorageService,
          secureStorageService: secureStorageService,
          persistentStorageService: persistentStorageService,
          deviceInfo: deviceInfo,
        );

        persistentStorageService.initializeBaseApiUrl();

        registerModels();

        _isInitialized = true;
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    }

    return instance;
  }

  /// Initializes the reCAPTCHA configuration.
  ///
  /// **Parameters:**
  /// - `captchaConfig`: The configuration for reCAPTCHA.
  static initCaptcha({
    required RecaptchaConfig captchaConfig,
  }) {
    instance._initCaptcha(captchaConfig: captchaConfig);
  }

  /// Private method to set the reCAPTCHA configuration.
  ///
  /// **Parameters:**
  /// - `captchaConfig`: The configuration for reCAPTCHA.
  void _initCaptcha({
    required RecaptchaConfig captchaConfig,
  }) {
    _captchaConfig = captchaConfig;
  }

  /// Registers JSON models used in the application.
  static void registerModels() {
    getIt.registerFactory<AppUser>(() => AppUser());
    getIt.registerFactory<EnumModel>(() => EnumModel());
    getIt.registerFactory<File>(() => File());
    getIt.registerFactory<ImageModel>(() => ImageModel());
    getIt.registerFactory<Tenant>(() => Tenant());
    getIt.registerFactory<UserNotification>(() => UserNotification());
  }

  /// Singleton instance of [AadOAuth] for Azure AD authentication.
  ///
  /// **Returns:**
  /// - The [AadOAuth] instance for Azure AD authentication.
  late AadOAuth azureAuth;

  bool _isAzureAdInitialized = false;

  /// Getter for the [AadOAuth] instance for Azure AD authentication.
  ///
  /// **Returns:**
  /// - The [AadOAuth] instance for Azure AD authentication.
  bool get useAzureAd => _isAzureAdInitialized;

  /// Initializes the Azure AD authentication configuration.
  ///
  /// **Parameters:**
  /// - `tenantId`: The Azure AD tenant ID.
  /// - `clientId`: The Azure AD client ID.
  /// - `redirectUri`: The redirect URI for authentication.
  /// - `navigationKey`: The navigator key for the application.
  static void initializeAzureAd({
    required String tenantId,
    required String clientId,
    required String redirectUri,
    required GlobalKey<NavigatorState> navigationKey,
  }) {
    final config = Config(
      tenant: tenantId,
      clientId: clientId,
      scope: "openid profile email",
      navigatorKey: navigationKey,
      redirectUri: redirectUri,
      webUseRedirect: true,
    );
    instance.azureAuth = AadOAuth(config);
    instance._isAzureAdInitialized = true;
  }
}

/// Getter for the [CookieStorageService] instance.
CookieStorageService get cookieStorageService =>
    SupaApplication.instance.cookieStorageService;

/// Getter for the [SecureStorageService] instance.
SecureStorageService get secureStorageService =>
    SupaApplication.instance.secureStorageService;

/// Getter for the [PersistentStorageService] instance.
PersistentStorageService get persistentStorageService =>
    SupaApplication.instance.persistentStorageService;

/// Provides access to the [SupaApplication] singleton instance.
SupaApplication get supaApplication => SupaApplication.instance;
