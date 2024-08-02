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

  Future<void> setCookies(
    List<Cookie> cookies, {
    bool deleteAll = false,
  });

  Future<void> logout();

  Future<void> deleteAccessTokenOnly();

  Future<void> deleteCookies();

  Future<List<Cookie>> getAuthenticationCookies();

  Future<String> buildUrlWithToken(String fileUrl);
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
  Future<void> logout() async {
    return persistCookieJar.deleteAll();
  }

  @override
  Future<void> deleteAccessTokenOnly() async {
    final cookies = await persistCookieJar.loadForRequest(_authenticationUri);
    final newCookies = cookies
        .where((cookie) => cookie.name.toLowerCase() != 'token')
        .toList();
    await persistCookieJar.delete(_rpcUri);
    await persistCookieJar.saveFromResponse(_authenticationUri, newCookies);
  }

  @override
  Future<List<Cookie>> getAuthenticationCookies() {
    return persistCookieJar.loadForRequest(_authenticationUri);
  }

  @override
  Future<String> buildUrlWithToken(String fileUrl) async {
    final cookies = await persistCookieJar.loadForRequest(_rpcUri);
    final uri = Uri.parse(fileUrl);
    final queryParameters = uri.queryParameters;
    return uri.replace(queryParameters: {
      ...queryParameters,
      'token': cookies.accessToken,
    }).toString();
  }

  @override
  Future<void> deleteCookies() async {
    await persistCookieJar.deleteAll();
  }
}

extension _CookiesExtensions on List<Cookie> {
  String get accessToken =>
      firstWhere((cookie) => cookie.name.toLowerCase() == 'token').value;

  String get refreshToken =>
      firstWhere((cookie) => cookie.name.toLowerCase() == 'refreshtoken').value;
}
