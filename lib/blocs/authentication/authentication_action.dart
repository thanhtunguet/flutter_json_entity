part of "authentication_bloc.dart";

/// Enumeration of authentication statuses.
enum AuthenticationAction {
  loginWithGoogle,
  loginWithApple,
  loginWithMicrosoft,
  loginWithBiometrics,
  loginWithPassword,
  logout,
}
