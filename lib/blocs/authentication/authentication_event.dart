part of 'authentication_bloc.dart';

/// Event triggered when an authentication error occurs.
final class AuthenticationErrorEvent extends AuthenticationEvent {
  /// The error that occurred during authentication.
  final dynamic error;

  /// Constructs an instance of [AuthenticationErrorEvent].
  ///
  /// **Parameters:**
  /// - `error`: The error that occurred.
  const AuthenticationErrorEvent(this.error);

  @override
  List<Object> get props => ['AuthenticationErrorEvent', error];
}

/// Abstract base class for all authentication events.
sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered to finalize the authentication process.
final class AuthenticationFinalEvent extends AuthenticationEvent {
  /// The authenticated user.
  final AppUser appUser;

  /// The authenticated tenant.
  final Tenant tenant;

  /// Constructs an instance of [AuthenticationFinalEvent].
  ///
  /// **Parameters:**
  /// - `appUser`: The authenticated user.
  /// - `tenant`: The authenticated tenant.
  const AuthenticationFinalEvent({
    required this.appUser,
    required this.tenant,
  });

  @override
  List<Object> get props => ['AuthenticationFinalEvent', appUser, tenant];
}

/// Event triggered to initialize the authentication process.
final class AuthenticationInitialEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationInitialEvent'];
}

/// Event triggered to log out the user.
final class AuthenticationLogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationLogoutEvent'];
}

/// Event triggered when the tenant is changed.
final class AuthenticationTenantChangedEvent extends AuthenticationEvent {
  /// The new tenant.
  final Tenant tenant;

  /// Constructs an instance of [AuthenticationTenantChangedEvent].
  ///
  /// **Parameters:**
  /// - `tenant`: The new tenant.
  const AuthenticationTenantChangedEvent({
    required this.tenant,
  });

  @override
  List<Object> get props => ['AuthenticationTenantChangedEvent', tenant];
}

/// Event triggered when a tenant is selected.
final class AuthenticationTenantSelectedEvent extends AuthenticationEvent {
  /// The selected tenant.
  final Tenant tenant;

  /// Constructs an instance of [AuthenticationTenantSelectedEvent].
  ///
  /// **Parameters:**
  /// - `tenant`: The selected tenant.
  const AuthenticationTenantSelectedEvent({
    required this.tenant,
  });

  @override
  List<Object> get props => ['AuthenticationTenantSelectedEvent', tenant];
}

/// Event triggered when tenants are loaded.
final class AuthenticationTenantsLoadedEvent extends AuthenticationEvent {
  /// The list of loaded tenants.
  final List<Tenant> tenants;

  /// Constructs an instance of [AuthenticationTenantsLoadedEvent].
  ///
  /// **Parameters:**
  /// - `tenants`: The list of loaded tenants.
  const AuthenticationTenantsLoadedEvent({
    required this.tenants,
  });

  @override
  List<Object> get props =>
      ['AuthenticationTenantsLoadedEvent', tenants, ...tenants];
}

/// Event triggered to initiate Apple login.
final class AuthenticationWithAppleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationWithAppleEvent'];
}

/// Event triggered to initiate biometric login.
final class AuthenticationWithBiometricEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationWithBiometricEvent'];
}

/// Event triggered to initiate Google login.
final class AuthenticationWithGoogleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationWithGoogleEvent'];
}

/// Event triggered to initiate Microsoft login.
final class AuthenticationWithMicrosoftEvent extends AuthenticationEvent {
  @override
  List<Object> get props => ['AuthenticationWithMicrosoftEvent'];
}

/// Event triggered to initiate password login.
final class AuthenticationWithPasswordEvent extends AuthenticationEvent {
  /// The username used for login.
  final String username;

  /// The password used for login.
  final String password;

  /// Constructs an instance of [AuthenticationWithPasswordEvent].
  ///
  /// **Parameters:**
  /// - `username`: The username used for login.
  /// - `password`: The password used for login.
  const AuthenticationWithPasswordEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props =>
      ['AuthenticationWithPasswordEvent', username, password];
}
