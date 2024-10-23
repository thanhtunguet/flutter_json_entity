import "package:cookie_jar/cookie_jar.dart";
import "package:dio_cookie_manager/dio_cookie_manager.dart";
import "package:path_provider/path_provider.dart";
import "package:supa_architecture/supa_architecture.dart";

/// An abstract class for managing cookie storage and related operations.
///
/// Provides methods for initializing cookie storage, setting cookies,
/// logging out, deleting access tokens and cookies, retrieving authentication
/// cookies, and building URLs with tokens.
abstract interface class CookieStorageService {
  /// Initializes the [CookieStorageService] by setting up a persistent
  /// cookie jar.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to an instance of [CookieStorageService].
  static Future<CookieStorageService> initialize() async {
    final documentsDir = await getApplicationCacheDirectory();

    PersistCookieJar persistCookieJar = PersistCookieJar(
      storage: FileStorage(documentsDir.path),
    );

    return _CookieStorageServiceImpl._(
      persistCookieJar: persistCookieJar,
    );
  }

  /// Returns a [CookieManager] for managing cookies with Dio.
  CookieManager getCookieManager();

  /// Sets the provided cookies.
  ///
  /// **Parameters:**
  /// - `cookies`: The list of [Cookie] objects to be set.
  /// - `deleteAll`: A boolean indicating whether to delete all existing cookies
  ///   before setting the new ones. Defaults to `false`.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the cookies have been set.
  Future<void> setCookies(
    List<Cookie> cookies, {
    bool deleteAll = false,
  });

  /// Logs out by deleting all cookies.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the cookies have been deleted.
  Future<void> logout();

  /// Deletes only the access token from the cookies.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the access token has been deleted.
  Future<void> deleteAccessTokenOnly();

  /// Deletes all cookies.
  ///
  /// **Returns:**
  /// - A [Future] that completes when all cookies have been deleted.
  Future<void> deleteCookies();

  /// Retrieves the authentication cookies.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of authentication [Cookie] objects.
  Future<List<Cookie>> getAuthenticationCookies();

  /// Builds a URL with the access token appended as a query parameter.
  ///
  /// **Parameters:**
  /// - `fileUrl`: The URL to which the token should be appended.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the URL with the token appended.
  Future<String> buildUrlWithToken(String fileUrl);
}

/// Implementation of the [CookieStorageService] interface.
///
/// Uses a [PersistCookieJar] for persistent cookie storage and provides
/// methods for managing cookies.
class _CookieStorageServiceImpl implements CookieStorageService {
  final PersistCookieJar persistCookieJar;

  static const _authenticationPath = "/rpc/portal/authentication";
  static const _rpcPath = "/rpc/";

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
        .where((cookie) => cookie.name.toLowerCase() != "token")
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
      "token": cookies.accessToken,
    }).toString();
  }

  @override
  Future<void> deleteCookies() async {
    await persistCookieJar.delete(_authenticationUri);
    await persistCookieJar.delete(_rpcUri);
  }
}

/// Extension methods for working with lists of [Cookie] objects.
extension _CookiesExtensions on List<Cookie> {
  /// Retrieves the access token from the list of cookies.
  ///
  /// **Returns:**
  /// - The access token as a [String].
  String get accessToken =>
      firstWhere((cookie) => cookie.name.toLowerCase() == "token").value;
}
