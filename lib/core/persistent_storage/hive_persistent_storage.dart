import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

class HivePersistentStorage extends PersistentStorage {
  static const String _boxName = 'supa_architecture';

  static const String _authBoxName = 'supa_auth';

  static const String _tenantKey = 'tenant';

  static const String _appUserKey = 'appUser';

  static const String _baseApiUrlKey = 'baseApiUrl';

  late final Box<dynamic> _defaultBox;

  late final Box _authBox;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();

    GetIt.instance.registerSingleton<PersistentStorage>(this);

    _defaultBox = await Hive.openBox<dynamic>(_boxName)
        .then((box) => box)
        .catchError((error) {
      throw HiveInitializationException(
        "Failed to initialize Hive box: $error",
        error: error,
      );
    });

    _authBox =
        await Hive.openBox(_authBoxName).then((box) => box).catchError((error) {
      throw HiveInitializationException(
        "Failed to initialize Hive box: $error",
        error: error,
      );
    });
  }

  @override
  void setValue(String key, String value) {
    _defaultBox.put(key, value);
  }

  @override
  String? getValue(String key) {
    return _defaultBox.get(key);
  }

  @override
  void removeValue(String key) {
    _defaultBox.delete(key);
  }

  @override
  void clear() {
    _authBox.clear();
  }

  @override
  String get baseApiUrl {
    String? url = _defaultBox.get(_baseApiUrlKey);
    if (url == null || url.isEmpty == true) {
      url = SupaArchitecturePlatform.instance.getBaseUrl();
      baseApiUrl = url;
    }
    return url;
  }

  @override
  set baseApiUrl(String baseApiUrl) {
    _defaultBox.put(_baseApiUrlKey, baseApiUrl);
  }

  @override
  Tenant? get tenant {
    final tenantJson = _authBox.get(_tenantKey);

    if (tenantJson != null && tenantJson is Map) {
      Tenant tenant = Tenant();
      tenant.fromJson(tenantJson);
      return tenant;
    }
    return null;
  }

  @override
  set tenant(Tenant? tenant) {
    _authBox.put(_tenantKey, tenant?.toJson());
  }

  @override
  void removeTenant() {
    _authBox.delete(_tenantKey);
  }

  @override
  AppUser? get appUser {
    final appUserJson = _authBox.get(_appUserKey);

    if (appUserJson != null && appUserJson is Map) {
      AppUser appUser = AppUser();
      appUser.fromJson(appUserJson);
      return appUser;
    }
    return null;
  }

  @override
  set appUser(AppUser? appUser) {
    _authBox.put(_appUserKey, appUser?.toJson());
  }

  @override
  void removeAppUser() {
    _authBox.delete(_appUserKey);
  }
}

class HiveInitializationException implements Exception {
  final String message;

  final Exception? error;

  HiveInitializationException(
    this.message, {
    this.error,
  });
}
