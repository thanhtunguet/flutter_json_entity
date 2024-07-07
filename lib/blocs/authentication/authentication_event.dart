part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

final class AuthenticationInitialEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [
        'AuthenticationInitialEvent',
      ];
}

final class AuthenticationWithPasswordEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithPasswordEvent',
        username,
        password,
      ];

  final String username;

  final String password;

  const AuthenticationWithPasswordEvent({
    required this.username,
    required this.password,
  });
}

final class AuthenticationWithGoogleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithGoogleEvent',
      ];
}

final class AuthenticationWithAppleEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithAppleEvent',
      ];
}

final class AuthenticationWithMicrosoftEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithMicrosoftEvent',
      ];
}

final class AuthenticationWithBiometricEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationWithBiometricEvent',
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

final class AuthenticationLogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
        'AuthenticationLogoutEvent',
      ];
}

final class AuthenticationErrorEvent extends AuthenticationEvent {
  final Error error;

  @override
  List<Object> get props => [
        'AuthenticationErrorEvent',
      ];

  const AuthenticationErrorEvent(this.error);
}
