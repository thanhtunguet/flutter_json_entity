import 'package:dio/dio.dart';
import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/supa_architecture.dart';

class PortalAuthenticationRepository extends ApiClient {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(path: '/rpc/portal/mobile/authentication')
      .toString();

  Future<void> refreshToken() async {
    final dio = Dio();
    dio.interceptors.add(cookieStorageService.getCookieManager());
    dio.options.baseUrl = persistentStorageService.baseApiUrl;

    final refreshTokenUrl = Uri.parse(persistentStorageService.baseApiUrl)
        .replace(path: '/rpc/portal/authentication/refresh-token')
        .toString();

    return dio.post(
      refreshTokenUrl,
      data: {},
    ).then(
      (response) => response.data,
    );
  }

  /// Password Login
  Future<List<Tenant>> login(String username, String password) async {
    return dio.post('/login', data: {
      'username': username,
      'password': password,
    }).then((response) => response.bodyAsList<Tenant>());
  }

  /// Google Login
  Future<List<Tenant>> loginWithGoogle(String idToken) async {
    return dio.post(
      '/google-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Apple Login
  Future<List<Tenant>> loginWithApple(String idToken) async {
    return dio.post(
      '/apple-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  /// Microsoft Login
  Future<List<Tenant>> loginWithMicrosoft(String idToken) async {
    return dio.post(
      '/microsoft-login',
      data: {
        'idToken': idToken,
      },
    ).then((response) => response.bodyAsList<Tenant>());
  }

  Future<void> createToken(Tenant tenant) async {
    return dio
        .post(
          '/create-token',
          data: tenant.toJSON(),
        )
        .then((response) => response.data);
  }

  Future<AppUser> getProfile() async {
    final url = Uri.parse(baseUrl)
        .replace(
          path: '/rpc/portal/app-user-profile/get',
        )
        .toString();
    return dio.post(url, data: {}).then(
      (response) => response.body<AppUser>(),
    );
  }

  saveAuthentication(AppUser appUser, Tenant tenant) {
    persistentStorageService.tenant = tenant;
    persistentStorageService.appUser = appUser;
  }

  TenantAuthentication? loadAuthentication() {
    final tenant = persistentStorageService.tenant;
    final appUser = persistentStorageService.appUser;

    if (tenant != null && appUser != null) {
      return TenantAuthentication(tenant, appUser);
    }

    return null;
  }

  void removeAuthentication() {
    persistentStorageService.logout();
  }
}

class TenantAuthentication {
  final Tenant tenant;

  final AppUser appUser;

  TenantAuthentication(this.tenant, this.appUser);
}
