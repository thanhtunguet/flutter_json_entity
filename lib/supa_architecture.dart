library supa_architecture;

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/data/app_user.dart';
import 'package:supa_architecture/data/enum_model.dart';
import 'package:supa_architecture/data/file.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/services/cookie_storage_service.dart';
import 'package:supa_architecture/services/persistent_storage_service.dart';
import 'package:supa_architecture/services/secure_storage_service.dart';

export 'api_client/api_client.dart';
export 'blocs/blocs.dart';
export 'data/app_token.dart';
export 'data/app_user.dart';
export 'data/device_notification_token.dart';
export 'data/enum_model.dart';
export 'data/file.dart';
export 'filters/filters.dart';
export 'json/json.dart';
export 'repositories/base_repository.dart';
export 'widgets/widgets.dart';

class SupaApplication {
  static late final SupaApplication instance;

  static bool _isInitialized = false;

  final CookieStorageService cookieStorageService;

  final SecureStorageService secureStorageService;

  final PersistentStorageService persistentStorageService;

  SupaApplication._({
    required this.cookieStorageService,
    required this.secureStorageService,
    required this.persistentStorageService,
  });

  static Future<SupaApplication> initialize() async {
    if (!_isInitialized) {
      await dotenv.load();

      final cookieStorageService = await CookieStorageService.initialize();
      final persistentStorageService =
          await PersistentStorageService.initialize();
      final secureStorageService = SecureStorageService.initialize();

      instance = SupaApplication._(
        cookieStorageService: cookieStorageService,
        secureStorageService: secureStorageService,
        persistentStorageService: persistentStorageService,
      );

      persistentStorageService.initializeBaseApiUrl();
      registerModels();

      _isInitialized = true;
    }

    return instance;
  }

  static registerModels() {
    JsonModel.registerType(AppUser, AppUser.new);
    JsonModel.registerType(EnumModel, EnumModel.new);
    JsonModel.registerType(File, File.new);
    JsonModel.registerType(Tenant, Tenant.new);
  }

  static late AadOAuth azureAuth;

  static void initializeAzureAd({
    required String tenantId,
    required String clientId,
    required String redirectUri,
    required GlobalKey<NavigatorState> navigationKey,
  }) {
    final config = Config(
      tenant: tenantId,
      clientId: clientId,
      scope: "openid profile",
      navigatorKey: navigationKey,
      redirectUri: redirectUri,
      webUseRedirect: true,
    );
    azureAuth = AadOAuth(config);
  }
}

CookieStorageService get cookieStorageService =>
    SupaApplication.instance.cookieStorageService;

SecureStorageService get secureStorageService =>
    SupaApplication.instance.secureStorageService;

PersistentStorageService get persistentStorageService =>
    SupaApplication.instance.persistentStorageService;
