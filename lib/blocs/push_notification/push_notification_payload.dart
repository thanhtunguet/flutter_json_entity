part of 'push_notification_bloc.dart';

/// Push notification payload
class PushNotificationPayload {
  /// Title mobile
  final String titleMobile;

  /// Created at
  final String createdAt;

  /// Link mobile
  final String linkMobile;

  /// Data
  final Map<String, dynamic>? data;

  /// Push notification payload
  PushNotificationPayload({
    required this.titleMobile,
    required this.createdAt,
    required this.linkMobile,
    this.data,
  });

  /// Factory method to create an instance of PushNotificationPayload from JSON
  factory PushNotificationPayload.fromJson(dynamic json) {
    Map<String, dynamic> jsonMap;
    if (json is Map<String, dynamic>) {
      jsonMap = json;
    } else {
      if (json is String) {
        try {
          jsonMap = jsonDecode(json);
        } catch (error) {
          jsonMap = {};
        }
      } else {
        jsonMap = {};
      }
    }

    return PushNotificationPayload(
      titleMobile: jsonMap['TitleMobile'] ?? '',
      createdAt: jsonMap['CreatedAt'] ?? '',
      linkMobile: jsonMap['LinkMobile'] ?? '',
      data: jsonMap,
    );
  }

  /// Convert the PushNotificationPayload instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'TitleMobile': titleMobile,
      'CreatedAt': createdAt,
      'LinkMobile': linkMobile,
      'Data': data,
    };
  }
}
