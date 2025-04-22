import "package:supa_architecture/models/models.dart";

/// A class representing the authentication information for a tenant.
///
/// This class holds the tenant and the app user information required for authentication.
class TenantAuthentication {
  /// The tenant associated with the authentication.
  final CurrentTenant tenant;

  /// The app user associated with the authentication.
  final AppUser appUser;

  /// Constructs an instance of [TenantAuthentication].
  ///
  /// **Parameters:**
  /// - `tenant`: The tenant associated with the authentication.
  /// - `appUser`: The app user associated with the authentication.
  TenantAuthentication(this.tenant, this.appUser);
}
