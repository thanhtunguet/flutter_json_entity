import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/supa_architecture.dart';

/// An abstract interface class for managing persistent storage.
///
/// Provides methods for initializing storage, setting and getting values for
/// biometric authentication and API URLs, managing tenant and user data, and
/// handling logout operations.
abstract interface class PersistentStorageService {
  // Constants for keys
  static const String _tenantBoxName = 'tenant';
  static const String _userBoxName = 'user';

  /// Initializes the [PersistentStorageService] by setting up Hive storage.
  ///
  /// **Parameters:**
  /// - `boxName`: The name of the Hive box to open. Defaults to 'supa_architecture'.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to an instance of [PersistentStorageService].
  static Future<PersistentStorageService> initialize({
    String boxName = 'supa_architecture',
  }) async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
    return _PersistentStorageServiceImpl._(
      boxName: boxName,
    );
  }

  /// Sets whether biometric authentication is enabled.
  ///
  /// **Parameters:**
  /// - `isBiometricEnabled`: A boolean indicating whether biometric authentication is enabled.
  set isBiometricEnabled(bool isBiometricEnabled);

  /// Gets whether biometric authentication is enabled.
  ///
  /// **Returns:**
  /// - A boolean indicating whether biometric authentication is enabled.
  bool get isBiometricEnabled;

  /// Sets the base API URL.
  ///
  /// **Parameters:**
  /// - `baseApiUrl`: The base URL for the API.
  set baseApiUrl(String baseApiUrl);

  /// Gets the base API URL.
  ///
  /// **Returns:**
  /// - The base URL for the API.
  String get baseApiUrl;

  /// Initializes the base API URL.
  initializeBaseApiUrl();

  /// Gets the current tenant.
  ///
  /// **Returns:**
  /// - An instance of [Tenant] if available, otherwise `null`.
  Tenant? get tenant;

  /// Gets the current app user.
  ///
  /// **Returns:**
  /// - An instance of [AppUser] if available, otherwise `null`.
  AppUser? get appUser;

  /// Sets the current tenant.
  ///
  /// **Parameters:**
  /// - `tenant`: An instance of [Tenant].
  set tenant(Tenant? tenant);

  /// Sets the current app user.
  ///
  /// **Parameters:**
  /// - `appUser`: An instance of [AppUser].
  set appUser(AppUser? appUser);

  /// Logs out by clearing tenant and user data.
  logout();
}

/// Implementation of the [PersistentStorageService] interface.
///
/// Uses a Hive box for persistent storage and provides methods for managing
/// biometric settings, API URLs, tenant and user data, and logout operations.
class _PersistentStorageServiceImpl implements PersistentStorageService {
  static const String _isBiometricEnabledKey = 'isBiometricEnabled';
  static const String _baseApiUrlKey = 'baseApiUrl';

  final Box box;

  _PersistentStorageServiceImpl._({
    required String boxName,
  }) : box = Hive.box(boxName);

  @override
  set isBiometricEnabled(bool isBiometricEnabled) {
    box.put(_isBiometricEnabledKey, isBiometricEnabled);
  }

  @override
  bool get isBiometricEnabled => box.get(_isBiometricEnabledKey);

  @override
  String get baseApiUrl => box.get(_baseApiUrlKey) ?? dotenv.baseApiUrl;

  @override
  set baseApiUrl(String baseApiUrl) {
    box.put(_baseApiUrlKey, baseApiUrl);
  }

  @override
  initializeBaseApiUrl() {
    if (baseApiUrl.isEmpty) {
      return dotenv.baseApiUrl;
    }
    return baseApiUrl;
  }

  @override
  AppUser? get appUser {
    final json = box.get(PersistentStorageService._userBoxName);
    if (json == null) {
      return null;
    }
    final appUser = AppUser();
    appUser.fromJSON(json);
    return appUser;
  }

  @override
  set appUser(AppUser? appUser) {
    if (appUser == null) {
      box.clear();
      return;
    }
    box.put(
      PersistentStorageService._userBoxName,
      appUser.toJSON(),
    );
  }

  @override
  Tenant? get tenant {
    final json = box.get(PersistentStorageService._tenantBoxName);
    if (json == null) {
      return null;
    }
    final tenant = Tenant();
    tenant.fromJSON(json);
    return tenant;
  }

  @override
  set tenant(Tenant? tenant) {
    if (tenant == null) {
      box.clear();
      return;
    }
    box.put(
      PersistentStorageService._tenantBoxName,
      tenant.toJSON(),
    );
  }

  @override
  logout() {
    box.delete(PersistentStorageService._tenantBoxName);
    box.delete(PersistentStorageService._userBoxName);
  }
}
