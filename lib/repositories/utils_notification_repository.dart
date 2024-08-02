import 'package:supa_architecture/data/user_notification.dart';
import 'package:supa_architecture/data/user_notification_filter.dart';
import 'package:supa_architecture/supa_architecture.dart';

class UtilsNotificationRepository
    extends BaseRepository<UserNotification, UserNotificationFilter> {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(
        path: '/rpc/utils-notification/notification',
      )
      .toString();

  Future<bool> createToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          '/create-token',
          data: deviceNotificationToken.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  Future<bool> deleteToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          '/delete-token',
          data: deviceNotificationToken.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  Future<List<UserNotification>> listRead(UserNotificationFilter filter) async {
    return dio
        .post(
          '/list-read',
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  Future<List<UserNotification>> listUnread(
      UserNotificationFilter filter) async {
    return dio
        .post(
          '/list-unread',
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  Future<int> countRead(UserNotificationFilter filter) async {
    return dio
        .post(
          '/count-read',
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  Future<int> countUnread(UserNotificationFilter filter) async {
    return dio
        .post(
          '/count-unread',
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  Future<String> read(UserNotification userNotification) async {
    return dio
        .post(
          '/read',
          data: userNotification.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  Future<void> readAll() async {
    return dio.post(
      '/read-all',
      data: {},
    ).then(
      (response) => response.data,
    );
  }
}
