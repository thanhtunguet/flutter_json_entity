import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';
import 'package:web/web.dart' as html;

/// Persistent storage implementation for web using localStorage.
class WebPersistentStorage extends PersistentStorage {
  /// Gets the base API URL from the platform.
  @override
  String get baseApiUrl => SupaArchitecturePlatform.instance.getBaseUrl();

  /// No-op setter for `baseApiUrl` since it is managed by the platform.
  @override
  set baseApiUrl(String baseApiUrl) {
    // No operation needed
  }

  /// Initializes the web storage and registers this instance in GetIt.
  @override
  Future<void> initialize() async {
    GetIt.instance.registerSingleton<PersistentStorage>(this);
  }

  /// Sets a key-value pair in localStorage.
  @override
  void setValue(String key, String value) {
    html.window.localStorage[key] = value;
  }

  /// Retrieves the value for the given key from localStorage.
  @override
  String? getValue(String key) => html.window.localStorage[key];

  /// Removes the value for the given key from localStorage.
  @override
  void removeValue(String key) => html.window.localStorage.removeItem(key);

  /// Clears all values from localStorage.
  @override
  void clear() => html.window.localStorage.clear();

  /// Removes the tenant information from localStorage.
  @override
  void removeTenant() => html.window.localStorage.removeItem('tenant');

  /// Removes the app user information from localStorage.
  @override
  void removeAppUser() => html.window.localStorage.removeItem('appUser');

  /// Stores tenant information as a JSON string in localStorage.
  @override
  set tenant(Tenant? tenant) {
    if (tenant != null) {
      html.window.localStorage['tenant'] = jsonEncode(tenant.toJson());
    } else {
      removeTenant();
    }
  }

  /// Retrieves tenant information from localStorage.
  @override
  Tenant? get tenant {
    final tenantJson = html.window.localStorage['tenant'];
    if (tenantJson != null) {
      try {
        final tenantData = jsonDecode(tenantJson) as Map<String, dynamic>;
        final tenant = Tenant();
        tenant.fromJson(tenantData);
        return tenant;
      } catch (e) {
        // Handle potential JSON decoding errors
        removeTenant(); // Clear corrupted data
      }
    }
    return null;
  }

  /// Stores app user information as a JSON string in localStorage.
  @override
  set appUser(AppUser? appUser) {
    if (appUser != null) {
      html.window.localStorage['appUser'] = jsonEncode(appUser.toJson());
    } else {
      removeAppUser();
    }
  }

  /// Retrieves app user information from localStorage.
  @override
  AppUser? get appUser {
    final appUserJson = html.window.localStorage['appUser'];
    if (appUserJson != null) {
      try {
        final appUserData = jsonDecode(appUserJson) as Map<String, dynamic>;
        final appUser = AppUser();
        appUser.fromJson(appUserData);
        return appUser;
      } catch (e) {
        // Handle potential JSON decoding errors
        removeAppUser(); // Clear corrupted data
      }
    }
    return null;
  }
}
