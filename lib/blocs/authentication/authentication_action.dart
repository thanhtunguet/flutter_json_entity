part of "authentication_bloc.dart";

/// Enumeration of authentication statuses.
enum AuthenticationAction {
  initialize,
  loginWithGoogle,
  loginWithApple,
  loginWithMicrosoft,
  loginWithBiometrics,
  loginWithPassword,
  logout,
}
