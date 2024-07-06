import 'dart:io';

import 'package:equatable/equatable.dart';

class AppToken extends Equatable {
  static const String _accessTokenKey = 'Token';
  static const String _refreshTokenKey = 'RefreshToken';

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
      ];

  final String? accessToken;

  final String? refreshToken;

  const AppToken({
    this.refreshToken,
    this.accessToken,
  });

  AppToken.fromCookies(List<Cookie> cookies)
      : accessToken = cookies.where((cookie) => cookie.name == _accessTokenKey).first.value,
        refreshToken = cookies.where((cookie) => cookie.name == _refreshTokenKey).first.value;
}
