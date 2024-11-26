import "dart:async";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:supa_architecture/blocs/blocs.dart";
import "package:supa_architecture/core/cookie_manager/cookie_manager.dart";
import "package:supa_architecture/repositories/portal_authentication_repository.dart";
import "package:supa_architecture/supa_architecture_platform_interface.dart";

/// An interceptor for handling HTTP errors and refreshing tokens.
///
/// If a 401 Unauthorized error occurs, this interceptor will attempt to
/// refresh the token and retry the original request. It manages the token
/// refresh operation to ensure that concurrent requests do not trigger
/// multiple refresh operations.
class RefreshInterceptor extends InterceptorsWrapper {
  static Completer<void>? _refreshCompleter;

  @override
  onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_refreshCompleter == null) {
        _refreshCompleter = Completer<void>();
        try {
          await refreshToken();
          _refreshCompleter?.complete();
        } catch (refreshError) {
          _refreshCompleter?.completeError(refreshError);
        } finally {
          _refreshCompleter = null;
        }
      }

      try {
        await _refreshCompleter?.future;
        final dio = Dio();
        if (!kIsWeb) {
          dio.interceptors
              .add(SupaArchitecturePlatform.instance.cookieStorage.interceptor);
        }
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (refreshError) {
        GetIt.instance.get<AuthenticationBloc>().add(UserLogoutEvent());
        GetIt.instance.get<CookieManager>().deleteAllCookies();
        return handler.next(err);
      }
    } else {
      return handler.next(err);
    }
  }

  /// Refreshes the authentication token.
  ///
  /// This method is used by the refresh interceptor to obtain a new token
  /// when the current token has expired.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the token refresh operation is finished.
  static Future<void> refreshToken() async {
    GetIt.instance.get<PortalAuthenticationRepository>().refreshToken();
  }
}
