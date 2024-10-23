import "package:reactive_forms/reactive_forms.dart";

/// Forgot password form
class ForgotPasswordForm extends FormGroup {
  /// Forgot password form
  ForgotPasswordForm()
      : super({
          "email": FormControl<String>(
            value: "",
            validators: [
              Validators.required,
              Validators.email,
            ],
          ),
        });

  /// Email
  FormControl<String> get email => control("email") as FormControl<String>;
}
