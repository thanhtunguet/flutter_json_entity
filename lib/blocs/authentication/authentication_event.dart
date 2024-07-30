part of 'authentication_bloc.dart';

final class AuthenticationErrorEvent extends AuthenticationEvent {
  final dynamic error;

  const AuthenticationErrorEvent(this.error);

  @override
  List<Object> get props => [
        'AuthenticationErrorEvent',
      ];
}

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

final class AuthenticationFinalEvent extends AuthenticationEvent {
  final AppUser appUser;

  final Tenant tenant;

  const AuthenticationFinalEvent({
    required this.appUser,
    required this.tenant,
  });

  @override
  List<Object> get props => [
        'AuthenticationFinalEvent',
      ];
}

final class AuthenticationInitialEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [
        'AuthenticationInitialEvent',
      ];
}

final class AuthenticationLogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationLogoutEvent',
      ];
}

final class AuthenticationTenantChangedEvent extends AuthenticationEvent {
  final Tenant tenant;

  const AuthenticationTenantChangedEvent({
    required this.tenant,
  });

  @override
  List<Object> get props => [
        'AuthenticationTenantChangedEvent',
        tenant,
      ];
}

final class AuthenticationTenantSelectedEvent extends AuthenticationEvent {
  final Tenant tenant;

  const AuthenticationTenantSelectedEvent({
    required this.tenant,
  });

  @override
  List<Object> get props => [
        'AuthenticationTenantSelectedEvent',
        tenant,
      ];
}

final class AuthenticationTenantsLoadedEvent extends AuthenticationEvent {
  final List<Tenant> tenants;

  const AuthenticationTenantsLoadedEvent({
    required this.tenants,
  });

  @override
  List<Object> get props => [
        'AuthenticationTenantsLoadedEvent',
        tenants,
        ...tenants,
      ];
}

final class AuthenticationWithAppleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithAppleEvent',
      ];
}

final class AuthenticationWithBiometricEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithBiometricEvent',
      ];
}

final class AuthenticationWithGoogleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithGoogleEvent',
      ];
}

final class AuthenticationWithMicrosoftEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithMicrosoftEvent',
      ];
}

final class AuthenticationWithPasswordEvent extends AuthenticationEvent {
  final String username;
  final String password;

  const AuthenticationWithPasswordEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [
        'AuthenticationWithPasswordEvent',
        username,
        password,
      ];
}
