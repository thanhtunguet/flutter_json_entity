import 'package:reactive_forms/reactive_forms.dart';

/// A form for user login.
///
/// This form is used to validate and submit user login information.
class LoginForm extends FormGroup {
  /// Constructs a [LoginForm] with the specified initial email and password.
  ///
  /// **Parameters:**
  /// - `initialEmail`: The initial email address.
  /// - `initialPassword`: The initial password.
  LoginForm(String initialEmail, String initialPassword)
      : super({
          'email': FormControl<String>(
            value: initialEmail,
            validators: [
              Validators.required,
            ],
          ),
          'password': FormControl<String>(
            value: initialPassword,
            validators: [
              Validators.required,
            ],
          ),
        });

  /// The email control of the form.
  FormControl<String> get email => control('email') as FormControl<String>;

  /// The password control of the form.
  FormControl<String> get password =>
      control('password') as FormControl<String>;
}
