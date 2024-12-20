import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:web/web.dart' hide Response;

/// A [CookieManager] implementation for web browsers using `document.cookie`.
class WebCookieManager implements CookieManager {
  /// Returns a Dio interceptor for handling cookies.
  @override
  Interceptor get interceptor => InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
      );

  /// Handles the `onRequest` phase to add cookies to outgoing requests.
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    final cookies = loadCookies(uri);
    if (cookies.isNotEmpty) {
      options.headers['Cookie'] =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    }
    handler.next(options);
  }

  /// Handles the `onResponse` phase to extract cookies from incoming responses.
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri;
    final rawCookies = response.headers['set-cookie'] ?? [];
    final cookies =
        rawCookies.map((raw) => Cookie.fromSetCookieValue(raw)).toList();
    saveCookies(uri, cookies);
    handler.next(response);
  }

  /// Loads all cookies available for the current domain.
  @override
  List<Cookie> loadCookies(Uri uri) {
    final rawCookies = document.cookie;
    if (rawCookies.isEmpty) return [];
    return rawCookies.split('; ').map((rawCookie) {
      final parts = rawCookie.split('=');
      final name = parts[0].trim();
      final value = parts.length > 1 ? parts[1].trim() : '';
      return Cookie(name, value);
    }).toList();
  }

  /// Saves cookies to the browser for a specific URI.
  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=${cookie.value}; path=/; domain=${uri.host};';
    }
  }

  /// Deletes all cookies for a specific URI.
  @override
  void deleteCookies(Uri uri) {
    final cookies = loadCookies(uri);
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=; path=/; domain=${uri.host}; expires=Thu, 01 Jan 1970 00:00:00 GMT;';
    }
  }

  /// Deletes all cookies globally across the domain.
  @override
  void deleteAllCookies() {
    final cookies = loadCookies(Uri.parse(document.domain));
    for (final cookie in cookies) {
      document.cookie =
          '${cookie.name}=; path=/; domain=${document.domain}; expires=Thu, 01 Jan 1970 00:00:00 GMT;';
    }
  }

  /// Retrieves a single cookie by its name for a specific URI.
  @override
  Cookie getSingleCookie(Uri uri, String name) {
    final rawCookies = document.cookie;
    if (rawCookies.isEmpty) {
      throw Exception('Cookie not found: $name');
    }
    final cookieString = rawCookies
        .split('; ')
        .firstWhere((cookie) => cookie.startsWith('$name='), orElse: () => '');
    if (cookieString.isEmpty) {
      throw Exception('Cookie not found: $name');
    }
    final value = cookieString.split('=').skip(1).join('=');
    return Cookie(name, value);
  }

  /// Builds a URL with the token included as a query parameter.
  @override
  String buildUrlWithToken(String url) {
    // No implementation needed as tokens are usually passed via cookies.
    return url;
  }
}
