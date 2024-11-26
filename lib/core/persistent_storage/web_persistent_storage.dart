import 'dart:convert';
import 'dart:html' as html;

import 'package:get_it/get_it.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

class WebPersistentStorage extends PersistentStorage {
  @override
  String get baseApiUrl {
    return SupaArchitecturePlatform.instance.getBaseUrl();
  }

  @override
  set baseApiUrl(String baseApiUrl) {
    /// do nothing
  }

  @override
  Future<void> initialize() async {
    // No initialization needed for localStorage
    GetIt.instance.registerSingleton<PersistentStorage>(this);
  }

  @override
  void setValue(String key, String value) {
    html.window.localStorage[key] = value;
  }

  @override
  String? getValue(String key) {
    return html.window.localStorage[key];
  }

  @override
  void removeValue(String key) {
    html.window.localStorage.remove(key);
  }

  @override
  void clear() {
    html.window.localStorage.clear();
  }

  @override
  void removeTenant() {
    html.window.localStorage.remove('tenant');
  }

  @override
  void removeAppUser() {
    html.window.localStorage.remove('appUser');
  }

  @override
  set tenant(Tenant? tenant) {
    html.window.localStorage['tenant'] = jsonEncode(tenant?.toJson());
  }

  @override
  Tenant get tenant {
    final tenantJson = html.window.localStorage['tenant'];
    Tenant tenant = Tenant();
    if (tenantJson != null) {
      tenant.fromJson(jsonDecode(tenantJson));
    }
    return tenant;
  }

  @override
  set appUser(AppUser? appUser) {
    html.window.localStorage['appUser'] = jsonEncode(appUser?.toJson());
  }

  @override
  AppUser get appUser {
    final appUserJson = html.window.localStorage['appUser'];
    AppUser appUser = AppUser();
    if (appUserJson != null) {
      appUser.fromJson(jsonDecode(appUserJson));
    }
    return appUser;
  }
}
