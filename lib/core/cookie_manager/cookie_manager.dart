import 'dart:io';

import 'package:dio/dio.dart';

abstract class CookieManager {
  Interceptor get interceptor;

  List<Cookie> loadCookies(Uri uri);

  Cookie getSingleCookie(Uri uri, String name);

  void saveCookies(Uri uri, List<Cookie> cookies);

  void deleteCookies(Uri uri);

  void deleteAllCookies();

  String buildUrlWithToken(String url);
}
