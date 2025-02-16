import "package:supa_architecture/filters/filters.dart";

/// A class representing a filter for user notifications.
///
/// This class extends [DataFilter] and provides a list of filter fields
/// for user notifications.
class UserNotificationFilter extends DataFilter {
  /// List of filter fields for user notifications.
  ///
  /// Currently, this list is empty, but it can be extended to include
  /// specific filter criteria for user notifications.
  @override
  List<FilterField> get fields => [
        subSystemId,
      ];

  /// Whether the notification is unread.
  bool? unread;

  IdFilter subSystemId = IdFilter("subSystemId");

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json["unread"] = unread;
    return json;
  }
}
