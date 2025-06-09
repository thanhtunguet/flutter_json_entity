part of "push_notification_bloc.dart";

/// Push notification state
sealed class PushNotificationState {
  const PushNotificationState();

  /// Converts the PushNotificationOpened state to a JSON map.
  ///
  /// **Returns:**
  /// - A Map\<String, dynamic\> representing the state in JSON format.
  Map<String, dynamic> toJson();
}

/// Push notification initial state
final class PushNotificationInitial extends PushNotificationState {
  /// Push notification initial state
  const PushNotificationInitial();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

/// Push notification received state
final class PushNotificationReceived extends PushNotificationState {
  /// Push notification received state
  final String title;

  /// Push notification received state
  final String body;

  /// Push notification received state
  final PushNotificationPayload payload;

  /// Push notification received state
  final String? linkMobile;

  /// Push notification received state
  PushNotificationReceived({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });

  /// Push notification opened state
  DidUserOpenedNotificationEvent opened() {
    return DidUserOpenedNotificationEvent(
      title: title,
      body: body,
      payload: payload,
      linkMobile: linkMobile,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "payload": payload.toJson(),
      "linkMobile": linkMobile,
    };
  }
}

/// Push notification opened state
final class PushNotificationOpened extends PushNotificationState {
  /// Push notification received state
  final String title;

  /// Push notification received state
  final String body;

  /// Push notification received state
  final PushNotificationPayload payload;

  /// Push notification received state
  final String? linkMobile;

  /// Push notification opened state
  const PushNotificationOpened({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
      "payload": payload.toJson(),
      "linkMobile": linkMobile,
    };
  }
}
