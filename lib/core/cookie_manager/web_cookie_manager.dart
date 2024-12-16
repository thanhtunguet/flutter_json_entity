import 'dart:io';

import 'package:dio/dio.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:web/web.dart';

class WebCookieManager implements CookieManager {
  List<Interceptor> get _interceptors => [
        InterceptorsWrapper(),
      ];

  @override
  Interceptor get interceptor => _interceptors.first;

  @override
  List<Cookie> loadCookies(Uri uri) {
    // Browser's document.cookie stores cookies as a single string
    final rawCookies = document.cookie;
    final cookies = rawCookies.split('; ').map((rawCookie) {
      final parts = rawCookie.split('=');
      return Cookie(parts[0], parts[1]);
    }).toList();
    return cookies;
  }

  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    // The browser automatically handles setting cookies
    for (var cookie in cookies) {
      document.cookie =
          "${cookie.name}=${cookie.value}; path=/; domain=${uri.host};";
    }
  }

  @override
  void deleteCookies(Uri uri) {
    // Expire each cookie for the domain
    final cookies = loadCookies(uri);
    for (var cookie in cookies) {
      document.cookie =
          "${cookie.name}=; path=/; domain=${uri.host}; expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
  }

  @override
  void deleteAllCookies() {
    // Expire all cookies globally
    final cookies = loadCookies(Uri.parse(document.domain));
    for (var cookie in cookies) {
      document.cookie =
          "${cookie.name}=; path=/; domain=${document.domain}; expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
  }

  @override
  Cookie getSingleCookie(Uri uri, String name) {
    return Cookie(
      name,
      document.cookie
          .split('; ')
          .firstWhere((cookie) => cookie.startsWith('$name='))
          .split('=')[1],
    );
  }

  @override
  String buildUrlWithToken(String url) {
    return url;
  }
}
