import "package:flutter/material.dart";
import "package:local_auth/local_auth.dart";

/// A stateful widget that provides a button for biometric login.
///
/// This widget uses the `local_auth` package to handle biometric
/// authentication and provides a callback for handling authentication results.
final class BiometricLoginButton extends StatefulWidget {
  /// A function that renders the child widget based on the available biometric type.
  final Widget Function(BiometricType?) childRender;

  /// A callback function that is called after authentication is attempted.
  ///
  /// **Parameters:**
  /// - `authenticated`: A boolean indicating whether the authentication was successful.
  final Future<void> Function(bool) onAuthenticated;

  /// The reason for biometric authentication to be displayed to the user.
  final String reason;

  /// Constructs an instance of [BiometricLoginButton].
  ///
  /// **Parameters:**
  /// - `childRender`: A function that renders the child widget.
  /// - `reason`: The reason for biometric authentication.
  /// - `onAuthenticated`: A callback function that handles the authentication result.
  const BiometricLoginButton({
    super.key,
    required this.childRender,
    required this.reason,
    required this.onAuthenticated,
  });

  @override
  State<BiometricLoginButton> createState() => _BiometricLoginButtonState();
}

class _BiometricLoginButtonState extends State<BiometricLoginButton> {
  static final LocalAuthentication auth = LocalAuthentication();

  bool canCheckBiometrics = false;

  BiometricType? biometricType;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  /// Checks if the device supports biometric authentication and identifies the available biometric type.
  Future<void> _checkBiometricSupport() async {
    try {
      canCheckBiometrics =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        setState(() {
          biometricType = BiometricType.face;
        });
      } else if (availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak)) {
        setState(() {
          biometricType = BiometricType.strong;
        });
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        setState(() {
          biometricType = BiometricType.fingerprint;
        });
      } else {
        setState(() {
          biometricType = null;
        });
      }
    } catch (e) {
      setState(() {
        canCheckBiometrics = false;
        biometricType = null;
      });
    }
  }

  /// Authenticates the user using the specified reason.
  ///
  /// **Parameters:**
  /// - `reason`: The reason for authentication.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating whether the authentication was successful.
  Future<bool> _authenticated(String reason) async {
    return auth.authenticate(localizedReason: reason);
  }

  @override
  Widget build(BuildContext context) {
    if (!canCheckBiometrics) {
      return Container();
    }
    return GestureDetector(
      onTap: () async {
        final bool authenticated = await _authenticated(widget.reason);
        return widget.onAuthenticated(authenticated);
      },
      child: widget.childRender(biometricType),
    );
  }
}

/// An enumeration of possible biometric login errors.
enum BiometricLoginError {
  /// The device does not support biometric authentication.
  notSupported,

  /// Biometric authentication is not available on the device.
  notAvailable,

  /// No biometric credentials are enrolled on the device.
  notEnrolled,

  /// An unknown error occurred.
  unknown,
}
