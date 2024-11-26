import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:supa_architecture/core/app_token.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';

class HiveCookieManager implements CookieManager {
  static Future<HiveCookieManager> create() async {
    final box = await Hive.openBox<Map<dynamic, dynamic>>('supa_cookies');
    return HiveCookieManager(box);
  }

  final Box<Map<dynamic, dynamic>> _cookieBox;

  HiveCookieManager(this._cookieBox);

  @override
  Interceptor get interceptor => _interceptors.first;

  List<Interceptor> get _interceptors => [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final uri = options.uri;
            final cookies = loadCookies(uri);
            final cookieHeader =
                cookies.map((e) => "${e.name}=${e.value}").join('; ');
            if (cookieHeader.isNotEmpty) {
              options.headers['Cookie'] = cookieHeader;
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            final uri = response.requestOptions.uri;
            final rawCookies = response.headers['set-cookie'] ?? [];
            final cookies = rawCookies
                .map((raw) => Cookie.fromSetCookieValue(raw))
                .toList();
            saveCookies(uri, cookies);
            handler.next(response);
          },
        ),
      ];

  @override
  List<Cookie> loadCookies(Uri uri) {
    final hostKey = uri.host;
    final cookies = (_cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{})
            as Map<dynamic, dynamic>)
        .entries
        .map((entry) => Cookie(entry.key, entry.value))
        .toList();
    return cookies;
  }

  @override
  void saveCookies(Uri uri, List<Cookie> cookies) {
    final hostKey = uri.host;
    final Map<dynamic, dynamic> existingCookies =
        _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{})
            as Map<dynamic, dynamic>;
    final updatedCookies = Map<dynamic, dynamic>.from(existingCookies);

    for (var cookie in cookies) {
      updatedCookies[cookie.name] = cookie.value;
    }

    _cookieBox.put(hostKey, updatedCookies);
  }

  @override
  Cookie getSingleCookie(Uri uri, String name) {
    final hostKey = uri.host;
    final Map<dynamic, dynamic> cookies =
        _cookieBox.get(hostKey, defaultValue: <dynamic, dynamic>{}) ??
            <dynamic, dynamic>{};
    return Cookie(name, cookies[name] ?? '');
  }

  @override
  void deleteCookies(Uri uri) {
    final hostKey = uri.host;
    _cookieBox.delete(hostKey);
  }

  @override
  void deleteAllCookies() {
    _cookieBox.clear();
  }

  @override
  String buildUrlWithToken(String url) {
    final cookie = getSingleCookie(Uri.parse(url), AppToken.accessTokenKey);
    final parsedUri = Uri.parse(url);
    return parsedUri.replace(
      queryParameters: {
        ...parsedUri.queryParameters,
        AppToken.accessTokenKey.toLowerCase(): cookie.value,
      },
    ).toString();
  }
}
