import "package:reactive_forms/reactive_forms.dart";

/// Form for resetting password
class ResetPasswordForm extends FormGroup {
  /// Constructor for ResetPasswordForm
  ResetPasswordForm({
    bool enableOtpValidation = false,
  }) : super(
          {
            "password": FormControl<String>(
              value: "",
              validators: [
                Validators.required,
              ],
            ),
            "confirmPassword": FormControl<String>(
              value: "",
              validators: [
                Validators.required,
              ],
            ),
            "otpCode": FormControl<String>(
              value: "",
              validators: [
                if (enableOtpValidation) ...[
                  Validators.required,
                  Validators.pattern(r"^[0-9]{6}$"),
                ],
              ],
            ),
          },
          validators: [
            Validators.mustMatch(
              "password",
              "confirmPassword",
            ),
          ],
        );

  /// Password
  FormControl<String> get password =>
      control("password") as FormControl<String>;

  /// Confirm password
  FormControl<String> get confirmPassword =>
      control("confirmPassword") as FormControl<String>;

  /// OTP code
  FormControl<String> get otpCode => control("otpCode") as FormControl<String>;
}
