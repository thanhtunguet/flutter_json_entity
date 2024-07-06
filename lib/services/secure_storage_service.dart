import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageService {
  static SecureStorageService initialize() {
    return _SecureStorageServiceImpl();
  }

  Future<void> saveAuthenticationToken({
    required String refreshToken,
    String? accessToken,
  });
}

class _SecureStorageServiceImpl extends SecureStorageService {
  final secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveAuthenticationToken({
    required String refreshToken,
    String? accessToken,
  }) async {
    await secureStorage.write(key: 'refreshToken', value: refreshToken);
    if (accessToken != null) {
      await secureStorage.write(key: 'accessToken', value: accessToken);
    } else {
      await secureStorage.delete(key: 'accessToken');
    }
  }
}
