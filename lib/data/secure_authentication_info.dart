class SecureAuthenticationInfo {
  final String refreshToken;

  final String? accessToken;

  final num? tenantId;

  const SecureAuthenticationInfo({
    required this.refreshToken,
    this.accessToken,
    this.tenantId,
  });
}
