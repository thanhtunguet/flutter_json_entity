mixin PasswordFieldMixin {
  bool isShowPassword = false;

  toggleShowPassword() {
    isShowPassword = !isShowPassword;
  }
}
