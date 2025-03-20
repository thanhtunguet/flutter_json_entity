/// A mixin that provides functionality for managing password visibility.
mixin PasswordFieldMixin {
  /// Indicates whether the password is currently visible.
  bool isShowPassword = false;

  /// Toggles the visibility of the password.
  void toggleShowPassword() {
    isShowPassword = !isShowPassword;
  }
}
