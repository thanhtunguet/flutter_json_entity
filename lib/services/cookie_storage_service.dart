import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supa_architecture/supa_architecture.dart';

abstract interface class CookieStorageService {
  static Future<CookieStorageService> initialize() async {
    final documentsDir = await getApplicationCacheDirectory();

    PersistCookieJar persistCookieJar = PersistCookieJar(
      storage: FileStorage(documentsDir.path),
    );

    return _CookieStorageServiceImpl._(
      persistCookieJar: persistCookieJar,
    );
  }

  CookieManager getCookieManager();

  Future<List<Cookie>> getCookies();

  Future<void> setCookies(
    List<Cookie> cookies, {
    bool deleteAll = false,
  });

  Future<void> deleteToken();

  Future<void> logout();
}

class _CookieStorageServiceImpl implements CookieStorageService {
  final PersistCookieJar persistCookieJar;

  static const _authenticationPath = '/rpc/portal/authentication';
  static const _rpcPath = '/rpc/';

  static Uri get _authenticationUri =>
      Uri.parse(persistentStorageService.baseApiUrl)
          .replace(path: _authenticationPath);
  static Uri get _rpcUri =>
      Uri.parse(persistentStorageService.baseApiUrl).replace(path: _rpcPath);

  _CookieStorageServiceImpl._({
    required this.persistCookieJar,
  });

  @override
  CookieManager getCookieManager() {
    return CookieManager(persistCookieJar);
  }

  @override
  Future<List<Cookie>> getCookies() async {
    return persistCookieJar.loadForRequest(_authenticationUri);
  }

  @override
  Future<void> setCookies(
    List<Cookie> cookies, {
    bool deleteAll = false,
  }) async {
    if (deleteAll) {
      await persistCookieJar.deleteAll();
    }
    return persistCookieJar.saveFromResponse(_authenticationUri, cookies);
  }

  @override
  Future<void> deleteToken() async {
    final cookies = await persistCookieJar.loadForRequest(_authenticationUri);
    final newCookies =
        cookies.where((cookie) => cookie.name == 'RefreshToken').toList();
    await persistCookieJar.deleteAll();
    await persistCookieJar.saveFromResponse(_authenticationUri, newCookies);
  }

  @override
  Future<void> logout() async {
    return persistCookieJar.deleteAll();
  }
}
