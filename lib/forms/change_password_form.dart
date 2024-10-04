import 'package:reactive_forms/reactive_forms.dart';

/// Change password form
class ChangePasswordForm extends FormGroup {
  /// OTP regex
  static const otpRegex = r'^[0-9]{6}$';

  /// Password regex
  static const passwordRegex =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{10,}$';

  /// Change password form
  ChangePasswordForm()
      : super({
          'oldPassword': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
            ],
          ),
          'newPassword': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
              Validators.pattern(passwordRegex),
            ],
          ),
          'verifyNewPassword': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
              Validators.pattern(passwordRegex),
            ],
          ),
          'otpCode': FormControl<String>(
            value: '',
            validators: [
              Validators.required,
              Validators.pattern(otpRegex),
            ],
          ),
        }, validators: [
          Validators.mustMatch(
            'newPassword',
            'verifyNewPassword',
          ),
        ]);

  /// Old password
  FormControl<String> get oldPassword =>
      control('oldPassword') as FormControl<String>;

  /// New password
  FormControl<String> get newPassword =>
      control('newPassword') as FormControl<String>;

  /// Verify new password
  FormControl<String> get verifyNewPassword =>
      control('verifyNewPassword') as FormControl<String>;

  /// OTP code
  FormControl<String> get otpCode => control('otpCode') as FormControl<String>;
}
