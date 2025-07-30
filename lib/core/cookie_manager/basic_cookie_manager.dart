import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';

/// A basic implementation of [CookieManager] that provides minimal functionality.
/// Used as a fallback when the main cookie manager is not yet initialized.
class BasicCookieManager implements CookieManager {
  final Map<String, List<Cookie>> _cookies = {};

  @override
  Interceptor get interceptor => InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
      );

  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;
    final cookies = loadCookies(uri);
    if (cookies.isNotEmpty) {
      options.headers['Cookie'] =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
    }
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri;
    final rawCookies = response.headers['set-cookie'] ?? [];
    final cookies =
        rawCookies.map((raw) => Cookie.fromSetCookieValue(raw)).toList();
    saveCookies(uri, cookies);
    handler.next(response);
  }

  @override
  List<Cookie> loadCookies(Uri uri) {
    return _cookies[uri.host] ?? [];
  }

  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    final host = uri.host;
    if (!_cookies.containsKey(host)) {
      _cookies[host] = [];
    }
    _cookies[host]!.addAll(cookies);
  }

  @override
  Cookie getSingleCookie(Uri uri, String name) {
    final cookies = loadCookies(uri);
    final cookie = cookies.firstWhere(
      (cookie) => cookie.name == name,
      orElse: () => throw Exception('Cookie not found: $name'),
    );
    return cookie;
  }

  @override
  void deleteCookies(Uri uri) {
    _cookies.remove(uri.host);
  }

  @override
  void deleteAllCookies() {
    _cookies.clear();
  }

  @override
  String buildUrlWithToken(String url) {
    // Basic implementation - just return the URL as-is
    return url;
  }
}
