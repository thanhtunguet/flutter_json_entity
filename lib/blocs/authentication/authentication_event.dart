part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitialEvent extends AuthenticationEvent {}

final class AuthenticationWithPasswordEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [
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

final class AuthenticationWithGoogleEvent extends AuthenticationEvent {}

final class AuthenticationWithAppleEvent extends AuthenticationEvent {}

final class AuthenticationWithMicrosoftEvent extends AuthenticationEvent {}

final class AuthenticationWithBiometricEvent extends AuthenticationEvent {}

final class AuthenticationTenantsLoadedEvent extends AuthenticationEvent {
  final List<Tenant> tenants;

  const AuthenticationTenantsLoadedEvent({
    required this.tenants,
  });

  @override
  List<Object> get props => [
        tenants,
        ...tenants,
      ];
}

final class AuthenticationTenantSelectedEvent extends AuthenticationEvent {}

final class AuthenticationLogoutEvent extends AuthenticationEvent {}
