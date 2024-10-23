part of "authentication_bloc.dart";

/// Enumeration of authentication statuses.
enum AuthenticationStatus {
  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,

  /// Authentication status is unknown.
  unknown,

  /// Authentication process is in progress.
  loading,

  /// An error occurred during authentication.
  error,
}

/// State representing an error during authentication.
final class AuthenticationError extends AuthenticationState {
  /// The error that occurred.
  final dynamic error;

  /// Constructs an instance of [AuthenticationError].
  ///
  /// **Parameters:**
  /// - `error`: The error that occurred.
  const AuthenticationError(this.error);

  @override
  List<Object> get props => [status, error];

  @override
  AuthenticationStatus get status => AuthenticationStatus.error;
}

/// Initial state of the authentication process.
final class AuthenticationInitial extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;
}

/// State representing that authentication is in progress.
final class AuthenticationLoading extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.loading;
}

/// Abstract base class for all authentication states.
sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  /// Indicates if the user is authenticated.
  bool get isAuthenticated => status == AuthenticationStatus.authenticated;

  /// Indicates if the authentication process is in progress.
  bool get isLoading => status == AuthenticationStatus.loading;

  @override
  List<Object> get props => [status];

  /// The current authentication status.
  AuthenticationStatus get status;
}

/// State representing a successful authentication.
final class AuthenticationSuccess extends AuthenticationState {
  /// The authenticated tenant.
  final Tenant tenant;

  /// The authenticated user.
  final AppUser appUser;

  /// Constructs an instance of [AuthenticationSuccess].
  ///
  /// **Parameters:**
  /// - `tenant`: The authenticated tenant.
  /// - `appUser`: The authenticated user.
  const AuthenticationSuccess(this.tenant, this.appUser);

  @override
  List<Object> get props => [status, tenant, tenant.id.value, appUser];

  @override
  AuthenticationStatus get status => AuthenticationStatus.authenticated;

  /// Creates a copy of this state with a different tenant.
  ///
  /// **Parameters:**
  /// - `tenant`: The new tenant.
  ///
  /// **Returns:**
  /// - A new instance of [AuthenticationSuccess] with the new tenant.
  AuthenticationSuccess changeTenant(Tenant tenant) {
    return AuthenticationSuccess(tenant, appUser);
  }
}

/// State representing that multiple tenants are available for selection.
final class AuthenticationTenants extends AuthenticationState {
  /// The list of available tenants.
  final List<Tenant> tenants;

  /// Constructs an instance of [AuthenticationTenants].
  ///
  /// **Parameters:**
  /// - `tenants`: The list of available tenants.
  const AuthenticationTenants(this.tenants);

  @override
  List<Object> get props => [status, tenants, ...tenants];

  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;
}
