part of 'authentication_bloc.dart';

final class AuthenticationError extends AuthenticationState {
  final Error error;

  const AuthenticationError(this.error);

  @override
  List<Object> get props => [
        status,
        error,
      ];

  @override
  AuthenticationStatus get status => AuthenticationStatus.error;
}

final class AuthenticationInitial extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;
}

final class AuthenticationLoading extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.loading;
}

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  bool get isAuthenticated => status == AuthenticationStatus.authenticated;

  bool get isLoading => status == AuthenticationStatus.loading;

  @override
  List<Object> get props => [
        status,
      ];

  AuthenticationStatus get status;
}

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  unknown,
  loading,
  error,
}

final class AuthenticationSuccess extends AuthenticationState {
  final Tenant tenant;

  final AppUser appUser;

  const AuthenticationSuccess(this.tenant, this.appUser);

  @override
  List<Object> get props => [
        status,
        tenant,
        tenant.id.value,
        appUser,
      ];

  @override
  AuthenticationStatus get status => AuthenticationStatus.authenticated;

  AuthenticationSuccess changeTenant(Tenant tenant) {
    return AuthenticationSuccess(tenant, appUser);
  }
}

final class AuthenticationTenants extends AuthenticationState {
  final List<Tenant> tenants;

  const AuthenticationTenants(this.tenants);

  @override
  List<Object> get props => [status, tenants, ...tenants];

  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;
}
