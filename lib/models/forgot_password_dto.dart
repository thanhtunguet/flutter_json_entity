import "package:supa_architecture/json/json.dart";

/// A class representing a forgot password data transfer object.
///
/// This class extends [JsonModel] and contains the following fields:
///
/// - `oldPassword`: The old password.
/// - `newPassword`: The new password.
/// - `verifyNewPassword`: Verification of the new password.
/// - `otpCode`: The OTP code for verification.
class ForgotPasswordDto extends JsonModel {
  /// Used to pass data from the client to the server to change the current
  /// user"s password. The data is expected to be in JSON format.
  JsonString oldPassword = JsonString("oldPassword");

  /// The old password. This field is required.
  JsonString newPassword = JsonString("newPassword");

  /// The new password. This field is required.
  JsonString verifyNewPassword = JsonString("verifyNewPassword");

  /// The OTP code for verification.
  JsonString otpCode = JsonString("otpCode");

  @override
  List<JsonField> get fields => [
        oldPassword,
        newPassword,
        verifyNewPassword,
        otpCode,
      ];
}
