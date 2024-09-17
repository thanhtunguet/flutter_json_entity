import 'package:supa_architecture/supa_architecture.dart';

/// A repository class for managing user profiles.
///
/// This class extends [ApiClient] and provides methods for handling various
/// profile-related tasks such as switching email, switching notification
/// settings, obtaining OTP, and changing passwords.
class PortalProfileRepository extends ApiClient {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(
        path: '/rpc/portal/app-user-profile',
      )
      .toString();

  /// Switches the email of the specified user.
  ///
  /// **Parameters:**
  /// - `user`: The [AppUser] whose email is to be switched.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the updated [AppUser].
  Future<AppUser> switchEmail(AppUser user) async {
    return dio
        .post(
          '/switch-email',
          data: user.toJSON(),
        )
        .then(
          (response) => response.body<AppUser>(),
        );
  }

  /// Switches the notification settings of the specified user.
  ///
  /// **Parameters:**
  /// - `user`: The [AppUser] whose notification settings are to be switched.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the updated [AppUser].
  Future<AppUser> switchNotification(AppUser user) async {
    return dio
        .post(
          '/switch-notification',
          data: user.toJSON(),
        )
        .then(
          (response) => response.body<AppUser>(),
        );
  }

  /// Retrieves an OTP.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the OTP is retrieved.
  Future<void> getOtp() async {
    return dio.post(
      '/get-otp',
      data: {},
    ).then(
      (response) => response.data,
    );
  }

  /// Changes the password using OTP verification.
  ///
  /// **Parameters:**
  /// - `oldPassword`: The current password.
  /// - `newPassword`: The new password.
  /// - `verifyNewPassword`: The new password verification.
  /// - `otpCode`: The OTP code for verification.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the password is changed.
  Future<void> changePasswordOtp({
    required String? oldPassword,
    required String? newPassword,
    required String? verifyNewPassword,
    required String? otpCode,
  }) async {
    return dio.post(
      '/change-password-otp',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'verifyNewPassword': verifyNewPassword,
        'otpCode': otpCode,
      },
    ).then(
      (response) => response.data,
    );
  }
}
