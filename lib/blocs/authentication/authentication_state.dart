part of "authentication_bloc.dart";

sealed class AuthenticationState {
  const AuthenticationState();

  bool get isAuthenticated => this is UserAuthenticatedWithSelectedTenantState;

  bool get isSelectingTenant =>
      this is UserAuthenticatedWithMultipleTenantsState;

  bool get isLoading => this is AuthenticationProcessingState;

  bool get hasError => this is AuthenticationErrorState;
}

final class AuthenticationInitialState extends AuthenticationState {}

final class UserAuthenticatedState extends AuthenticationState {
  final AppUser user;

  const UserAuthenticatedState(this.user);
}

final class UserAuthenticatedWithMultipleTenantsState
    extends AuthenticationState {
  final List<Tenant> tenants;

  const UserAuthenticatedWithMultipleTenantsState({
    required this.tenants,
  });
}

final class UserAuthenticatedWithSelectedTenantState extends AuthenticationState
    with EquatableMixin {
  final AppUser user;

  final Tenant tenant;

  const UserAuthenticatedWithSelectedTenantState({
    required this.user,
    required this.tenant,
  });

  @override
  List<Object?> get props => [
        user,
        tenant,
        user.languageId.value,
        user.language.value.code.value,
      ];
}

final class AuthenticationLogoutState extends AuthenticationState {}

final class AuthenticationProcessingState extends AuthenticationState {
  final AuthenticationAction action;

  const AuthenticationProcessingState(this.action);
}

final class AuthenticationErrorState extends AuthenticationState {
  final String title;

  final String message;

  final Object? error;

  const AuthenticationErrorState({
    required this.title,
    required this.message,
    this.error,
  });
}
