import "dart:html" as html;
import "dart:io";

import "package:equatable/equatable.dart";
import "package:flutter/foundation.dart";

/// A class representing an application token, containing access and refresh tokens.
///
/// This class extends [Equatable] for value comparison and provides a
/// constructor for creating instances from a list of [Cookie]s.
class AppToken extends Equatable {
  static const String _accessTokenKey = "Token";
  static const String _refreshTokenKey = "RefreshToken";

  /// The access token.
  final String? accessToken;

  /// The refresh token.
  final String? refreshToken;

  /// Constructs an instance of [AppToken].
  ///
  /// **Parameters:**
  /// - `accessToken`: The access token.
  /// - `refreshToken`: The refresh token.
  const AppToken({
    this.accessToken,
    this.refreshToken,
  });

  /// Constructs an instance of [AppToken] from a list of [Cookie]s.
  ///
  /// **Parameters:**
  /// - `cookies`: The list of cookies from which to extract the tokens.
  AppToken.fromCookies(List<Cookie> cookies)
      : accessToken = cookies
            .where((cookie) => cookie.name == _accessTokenKey)
            .first
            .value,
        refreshToken = cookies
            .where((cookie) => cookie.name == _refreshTokenKey)
            .first
            .value;

  /// Constructs an instance of [AppToken] from web cookies.
  AppToken.fromWebCookies()
      : accessToken = _getWebCookie(_accessTokenKey),
        refreshToken = _getWebCookie(_refreshTokenKey);

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
      ];
}

String? _getWebCookie(String name) {
  if (kIsWeb) {
    // Get all cookies as a single string
    String? cookies = html.document.cookie;

    // Split cookies into individual name-value pairs
    List<String> cookieList = cookies?.split('; ') ?? [];

    for (String cookie in cookieList) {
      // Split each cookie into a name and a value
      List<String> cookieParts = cookie.split('=');
      if (cookieParts.length == 2 && cookieParts[0] == name) {
        return cookieParts[1];
      }
    }
  }

  return null; // Return null if the cookie is not found
}
