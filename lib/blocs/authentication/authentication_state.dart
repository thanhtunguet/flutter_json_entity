part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  unknown,
  loading,
  error,
}

sealed class AuthenticationState extends Equatable {
  AuthenticationStatus get status;

  const AuthenticationState();

  @override
  List<Object> get props => [
        status,
      ];
}

final class AuthenticationInitial extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;
}

final class AuthenticationLoading extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.loading;
}

final class AuthenticationTenants extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.unknown;

  final List<Tenant> tenants;

  const AuthenticationTenants(this.tenants);

  @override
  List<Object> get props => [status, tenants, ...tenants];
}

final class AuthenticationSuccess extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.authenticated;

  final Tenant tenant;

  final AppUser appUser;

  const AuthenticationSuccess(this.tenant, this.appUser);

  @override
  List<Object> get props => [
        status,
        tenant,
        appUser,
      ];
}

final class AuthenticationError extends AuthenticationState {
  @override
  AuthenticationStatus get status => AuthenticationStatus.error;

  final Error error;

  const AuthenticationError(this.error);

  @override
  List<Object> get props => [
        status,
        error,
      ];
}
