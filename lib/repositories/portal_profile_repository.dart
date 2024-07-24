import 'package:supa_architecture/supa_architecture.dart';

class PortalProfileRepository extends ApiClient {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(path: '/rpc/portal/app-user-profile')
      .toString();

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

  Future<void> getOtp() async {
    return dio.post(
      '/get-otp',
      data: {},
    ).then(
      (response) => response.data,
    );
  }

  Future<void> changePasswordOtp({
    required String oldPassword,
    required String newPassword,
    required String verifyNewPassword,
    required String otpCode,
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
