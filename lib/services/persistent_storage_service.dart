import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/supa_architecture.dart';

abstract interface class PersistentStorageService {
  // Constants for keys
  static const String _tenantBoxName = 'tenant';
  static const String _userBoxName = 'user';

  static Future<PersistentStorageService> initialize({
    String boxName = 'supa_architecture',
  }) async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
    return _PersistentStorageServiceImpl._(
      boxName: boxName,
    );
  }

  set isBiometricEnabled(bool isBiometricEnabled);

  bool get isBiometricEnabled;

  set baseApiUrl(String baseApiUrl);

  String get baseApiUrl;

  initializeBaseApiUrl();

  Tenant? get tenant;

  AppUser? get appUser;

  set tenant(Tenant? tenant);

  set appUser(AppUser? appUser);

  logout();
}

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
