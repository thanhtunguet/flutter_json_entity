part of 'authentication_bloc.dart';

/// A class representing an error during authentication.
sealed class AuthenticationException extends Equatable {
  @override
  List<Object?> get props => [
        'AuthenticationException',
      ];
}

/// A class representing an error during Google login.
final class AuthenticationGoogleException extends AuthenticationException {
  @override
  List<Object?> get props => [
        'AuthenticationGoogleException',
      ];
}
