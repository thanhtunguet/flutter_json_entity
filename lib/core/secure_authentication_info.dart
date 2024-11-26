/// A class representing secure authentication information.
///
/// This class holds the tokens and tenant ID required for secure authentication.
class SecureAuthenticationInfo {
  /// The refresh token used for obtaining new access tokens.
  final String refreshToken;

  /// The optional access token for authentication.
  final String? accessToken;

  /// The optional tenant ID associated with the authentication.
  final num? tenantId;

  /// Constructs an instance of [SecureAuthenticationInfo].
  ///
  /// **Parameters:**
  /// - `refreshToken`: The refresh token used for obtaining new access tokens.
  /// - `accessToken`: The optional access token for authentication.
  /// - `tenantId`: The optional tenant ID associated with the authentication.
  const SecureAuthenticationInfo({
    required this.refreshToken,
    this.accessToken,
    this.tenantId,
  });
}
