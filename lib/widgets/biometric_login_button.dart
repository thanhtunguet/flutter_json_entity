import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

final class BiometricLoginButton extends StatefulWidget {
  final Widget Function(BiometricType) childRender;

  final Future<void> Function(bool) onAuthenticated;

  final String reason;

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

  bool _canCheckBiometrics = false;

  BiometricType? _biometricType;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        setState(() {
          _biometricType = BiometricType.face;
        });
      } else if (availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak)) {
        setState(() {
          _biometricType = BiometricType.strong;
        });
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        setState(() {
          _biometricType = BiometricType.fingerprint;
        });
      } else {
        setState(() {
          _biometricType = null;
        });
      }
    } catch (e) {
      setState(() {
        _canCheckBiometrics = false;
        _biometricType = null;
      });
    }
  }

  Future<bool> _authenticated(String reason) async {
    return auth.authenticate(localizedReason: reason);
  }

  @override
  Widget build(BuildContext context) {
    if (!_canCheckBiometrics) {
      return Container();
    }
    return InkWell(
      onTap: () async {
        final bool authenticated = await _authenticated(widget.reason);
        return widget.onAuthenticated(authenticated);
      },
      child: widget.childRender(_biometricType!),
    );
  }
}

enum BiometricLoginError {
  notSupported,
  notAvailable,
  notEnrolled,
  unknown,
}
