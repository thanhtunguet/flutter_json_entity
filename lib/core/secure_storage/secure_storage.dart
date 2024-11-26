import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/core/app_token.dart';
import 'package:supa_architecture/core/secure_authentication_info.dart';

class SecureStorage {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void initialize() {
    GetIt.instance.registerSingleton<SecureStorage>(this);
  }

  Future<void> saveAuthenticationInfo(SecureAuthenticationInfo info) async {
    final refreshToken = info.refreshToken;
    final accessToken = info.accessToken;
    final tenantId = info.tenantId;

    await secureStorage.write(
      key: AppToken.refreshTokenKey,
      value: refreshToken,
    );
    if (accessToken != null) {
      await secureStorage.write(
        key: AppToken.accessTokenKey,
        value: accessToken,
      );
    } else {
      await secureStorage.delete(key: AppToken.accessTokenKey);
    }
    if (tenantId != null) {
      await secureStorage.write(
        key: AppToken.tenantIdKey,
        value: tenantId.toString(),
      );
    } else {
      await secureStorage.delete(key: AppToken.tenantIdKey);
    }
  }

  Future<void> deleteAuthenticationInfo() {
    return secureStorage.deleteAll();
  }

  Future<SecureAuthenticationInfo?> getSavedAuthenticationInfo() async {
    final refreshToken =
        await secureStorage.read(key: AppToken.refreshTokenKey);
    if (refreshToken == null) {
      return null;
    }

    final accessToken = await secureStorage.read(key: AppToken.accessTokenKey);
    final tenantId = await secureStorage.read(key: AppToken.tenantIdKey);

    return SecureAuthenticationInfo(
      refreshToken: refreshToken,
      accessToken: accessToken,
      tenantId: int.tryParse(tenantId ?? ""),
    );
  }
}
