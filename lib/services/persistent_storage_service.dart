import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supa_architecture/extensions/dotenv.dart';

abstract interface class PersistentStorageService {
  static Future<PersistentStorageService> initialize({
    String boxName = 'supa_architecture',
  }) async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
    return _PersistentStorageServiceImpl._(
      boxName: boxName,
    );
  }

  set tenantId(int tenantId);

  int get tenantId;

  set userId(int userId);

  int get userId;

  set isBiometricEnabled(bool isBiometricEnabled);

  bool get isBiometricEnabled;

  set baseApiUrl(String baseApiUrl);

  String get baseApiUrl;

  initializeBaseApiUrl();
}

class _PersistentStorageServiceImpl implements PersistentStorageService {
  // Constants for keys
  static const String _tenantIdKey = 'tenantId';
  static const String _userIdKey = 'userId';
  static const String _isBiometricEnabledKey = 'isBiometricEnabled';
  static const String _baseApiUrlKey = 'baseApiUrl';

  final Box box;

  _PersistentStorageServiceImpl._({
    required String boxName,
  }) : box = Hive.box(boxName);

  @override
  set tenantId(int tenantId) {
    box.put(_tenantIdKey, tenantId);
  }

  @override
  int get tenantId => box.get(_tenantIdKey);

  @override
  set userId(int userId) {
    box.put(_userIdKey, userId);
  }

  @override
  int get userId => box.get(_userIdKey);

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
    baseApiUrl ??= dotenv.baseApiUrl;
  }
}
