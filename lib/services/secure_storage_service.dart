import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supa_architecture/data/secure_authentication_info.dart';

/// An abstract interface class for managing secure storage.
///
/// Provides methods for initializing secure storage, saving authentication
/// information, retrieving saved authentication information, and deleting
/// authentication information.
abstract interface class SecureStorageService {
  /// Initializes the [SecureStorageService].
  ///
  /// **Returns:**
  /// - An instance of [SecureStorageService].
  static SecureStorageService initialize() {
    return _SecureStorageServiceImpl();
  }

  /// Saves the authentication information securely.
  ///
  /// **Parameters:**
  /// - `info`: The [SecureAuthenticationInfo] containing authentication details.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the authentication information has been saved.
  Future<void> saveAuthenticationInfo(SecureAuthenticationInfo info);

  /// Retrieves the saved authentication information.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the [SecureAuthenticationInfo] if available,
  ///   otherwise `null`.
  Future<SecureAuthenticationInfo?> getSavedAuthenticationInfo();

  /// Deletes the saved authentication information.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the authentication information has been deleted.
  Future<void> deleteAuthenticationInfo();
}

/// Implementation of the [SecureStorageService] interface.
///
/// Uses [FlutterSecureStorage] for securely storing authentication information.
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
