import "package:reactive_forms/reactive_forms.dart";

/// A form for user login.
///
/// This form is used to validate and submit user login information.
class LoginForm extends FormGroup {
  /// Constructs a [LoginForm] with the specified initial email and password.
  ///
  /// **Parameters:**
  /// - `initialUsername`: The initial username.
  /// - `initialPassword`: The initial password.
  LoginForm(String initialUsername, String initialPassword)
      : super({
          "username": FormControl<String>(
            value: initialUsername,
            validators: [
              Validators.required,
            ],
          ),
          "password": FormControl<String>(
            value: initialPassword,
            validators: [
              Validators.required,
            ],
          ),
        });

  /// The email control of the form.
  FormControl<String> get username =>
      control("username") as FormControl<String>;

  /// The password control of the form.
  FormControl<String> get password =>
      control("password") as FormControl<String>;
}
