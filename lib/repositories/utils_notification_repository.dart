import "package:supa_architecture/supa_architecture.dart";

/// A repository class for managing user notifications.
///
/// This class extends [BaseRepository] and provides methods for handling
/// various notification tasks such as creating and deleting notification tokens,
/// listing read and unread notifications, counting read and unread notifications,
/// and marking notifications as read.
class UtilsNotificationRepository
    extends BaseRepository<UserNotification, UserNotificationFilter> {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(
        path: "/rpc/utils-notification/notification",
      )
      .toString();

  /// Creates a notification token for the device.
  ///
  /// **Parameters:**
  /// - `deviceNotificationToken`: The [DeviceNotificationToken] to create.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating the success of the operation.
  Future<bool> createToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          "/create-token",
          data: deviceNotificationToken.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Deletes a notification token for the device.
  ///
  /// **Parameters:**
  /// - `deviceNotificationToken`: The [DeviceNotificationToken] to delete.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a boolean indicating the success of the operation.
  Future<bool> deleteToken(
    DeviceNotificationToken deviceNotificationToken,
  ) async {
    return dio
        .post(
          "/delete-token",
          data: deviceNotificationToken.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Lists read notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the read notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [UserNotification]s.
  Future<List<UserNotification>> listRead(UserNotificationFilter filter) async {
    return dio
        .post(
          "/list-read",
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  /// Lists unread notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the unread notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [UserNotification]s.
  Future<List<UserNotification>> listUnread(
      UserNotificationFilter filter) async {
    return dio
        .post(
          "/list-unread",
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<UserNotification>(),
        );
  }

  /// Counts read notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the read notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of read notifications.
  Future<int> countRead(UserNotificationFilter filter) async {
    return dio
        .post(
          "/count-read",
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  /// Counts unread notifications based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [UserNotificationFilter] to filter the unread notifications.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of unread notifications.
  Future<int> countUnread(UserNotificationFilter filter) async {
    return dio
        .post(
          "/count-unread",
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  /// Marks a notification as read.
  ///
  /// **Parameters:**
  /// - `userNotification`: The [UserNotification] to mark as read.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a string response.
  Future<String> read(UserNotification userNotification) async {
    return dio
        .post(
          "/read",
          data: userNotification.toJSON(),
        )
        .then(
          (response) => response.data,
        );
  }

  /// Marks all notifications as read.
  ///
  /// **Returns:**
  /// - A [Future] that completes when all notifications are marked as read.
  Future<void> readAll() async {
    return dio.post(
      "/read-all",
      data: {},
    ).then(
      (response) => response.data,
    );
  }
}
