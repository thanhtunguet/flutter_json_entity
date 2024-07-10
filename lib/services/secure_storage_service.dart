import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supa_architecture/data/secure_authentication_info.dart';

abstract interface class SecureStorageService {
  static SecureStorageService initialize() {
    return _SecureStorageServiceImpl();
  }

  Future<void> saveAuthenticationInfo(SecureAuthenticationInfo info);

  Future<SecureAuthenticationInfo?> getSavedAuthenticationInfo();

  Future<void> deleteAuthenticationInfo();
}

class _SecureStorageServiceImpl extends SecureStorageService {
  final secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveAuthenticationInfo(SecureAuthenticationInfo info) async {
    final refreshToken = info.refreshToken;
    final accessToken = info.accessToken;
    final tenantId = info.tenantId;

    await secureStorage.write(key: 'refreshToken', value: refreshToken);
    if (accessToken != null) {
      await secureStorage.write(key: 'accessToken', value: accessToken);
    } else {
      await secureStorage.delete(key: 'accessToken');
    }
    if (tenantId != null) {
      await secureStorage.write(key: 'tenantId', value: tenantId.toString());
    } else {
      await secureStorage.delete(key: 'tenantId');
    }
  }

  @override
  Future<void> deleteAuthenticationInfo() {
    return secureStorage.deleteAll();
  }

  @override
  Future<SecureAuthenticationInfo?> getSavedAuthenticationInfo() async {
    final refreshToken = await secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) {
      return null;
    }

    final accessToken = await secureStorage.read(key: 'accessToken');
    final tenantId = await secureStorage.read(key: 'tenantId');

    return SecureAuthenticationInfo(
      refreshToken: refreshToken,
      accessToken: accessToken,
      tenantId: int.tryParse(tenantId ?? ''),
    );
  }
}
