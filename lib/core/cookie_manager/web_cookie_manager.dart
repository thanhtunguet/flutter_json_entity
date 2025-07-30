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

    // Handle each Set-Cookie header individually
    for (final rawCookie in rawCookies) {
      try {
        final cookie = Cookie.fromSetCookieValue(rawCookie);
        _saveCookieFromServer(uri, cookie, rawCookie);
      } catch (e) {
        // Log error but continue processing other cookies
        // ignore: avoid_print
        print('Error parsing cookie: $rawCookie - $e');
      }
    }

    handler.next(response);
  }

  /// Loads all cookies available for the current domain.
  @override
  List<Cookie> loadCookies(Uri uri) {
    final rawCookies = document.cookie;
    if (rawCookies.isEmpty) return [];
    return rawCookies.split('; ').map((rawCookie) {
      final firstEqualIndex = rawCookie.indexOf('=');
      if (firstEqualIndex == -1) return Cookie(rawCookie.trim(), '');
      final name = rawCookie.substring(0, firstEqualIndex).trim();
      final value = rawCookie.substring(firstEqualIndex + 1).trim();
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

  /// Saves a cookie from server response, preserving server-set attributes.
  void _saveCookieFromServer(Uri uri, Cookie cookie, String rawSetCookie) {
    // Extract the cookie name and value from the raw Set-Cookie header
    final parts = rawSetCookie.split(';');
    final nameValue = parts[0].trim();
    final firstEqualIndex = nameValue.indexOf('=');
    if (firstEqualIndex == -1) return;

    final name = nameValue.substring(0, firstEqualIndex).trim();
    final value = nameValue.substring(firstEqualIndex + 1).trim();

    // Build cookie string with server attributes
    final cookieString = StringBuffer('$name=$value');

    // Add server-set attributes (path, domain, expires, etc.)
    for (int i = 1; i < parts.length; i++) {
      final attr = parts[i].trim();
      if (attr.isNotEmpty) {
        cookieString.write('; $attr');
      }
    }

    document.cookie = cookieString.toString();
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
    final firstEqualIndex = cookieString.indexOf('=');
    if (firstEqualIndex == -1) {
      throw Exception('Cookie not found: $name');
    }
    final value = cookieString.substring(firstEqualIndex + 1);
    return Cookie(name, value);
  }

  /// Builds a URL with the token included as a query parameter.
  @override
  String buildUrlWithToken(String url) {
    // No implementation needed as tokens are usually passed via cookies.
    return url;
  }
}
