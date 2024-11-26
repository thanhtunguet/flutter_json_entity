part of "authentication_bloc.dart";

/// Abstract base class for all authentication events.
sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationInitializeEvent extends AuthenticationEvent {}

final class AuthenticationProcessingEvent extends AuthenticationEvent {
  final AuthenticationAction action;

  const AuthenticationProcessingEvent(this.action);
}

final class LoginWithGoogleEvent extends AuthenticationEvent {}

final class LoginWithAppleEvent extends AuthenticationEvent {}

final class LoginWithMicrosoftEvent extends AuthenticationEvent {}

final class LoginWithPasswordEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginWithPasswordEvent(
    this.email,
    this.password,
  );
}

final class LoginWithSavedLoginEvent extends AuthenticationEvent {}

final class UsingSavedAuthenticationEvent extends AuthenticationEvent {
  final Tenant tenant;

  final AppUser user;

  const UsingSavedAuthenticationEvent({
    required this.tenant,
    required this.user,
  });
}

final class LoginWithSelectedTenantEvent extends AuthenticationEvent {
  final Tenant tenant;

  const LoginWithSelectedTenantEvent({
    required this.tenant,
  });
}

final class LoginWithMultipleTenantsEvent extends AuthenticationEvent {
  final List<Tenant> tenants;

  const LoginWithMultipleTenantsEvent(this.tenants);
}

final class UserLogoutEvent extends AuthenticationEvent {}

final class AuthenticationErrorEvent extends AuthenticationEvent {
  final String title;
  final String message;
  final Object? error;

  const AuthenticationErrorEvent({
    required this.title,
    required this.message,
    this.error,
  });
}

final class UpdateAppUserProfileEvent extends AuthenticationEvent {
  final AppUser user;

  const UpdateAppUserProfileEvent(this.user);
}

final class AppUserSwitchEmailEvent extends AuthenticationEvent {
  const AppUserSwitchEmailEvent();
}

final class AppUserSwitchNotificationEvent extends AuthenticationEvent {
  const AppUserSwitchNotificationEvent();
}
