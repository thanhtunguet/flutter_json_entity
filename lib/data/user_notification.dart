import 'package:supa_architecture/supa_architecture.dart';

/// A class representing a user notification.
///
/// This class extends [JsonModel] and provides various fields representing
/// attributes of a user notification such as ID, title, content, links,
/// sender, recipient, and read status.
class UserNotification extends JsonModel {
  /// The ID of the notification.
  JsonInteger id = JsonInteger("id");

  /// The title of the notification.
  JsonString title = JsonString("title");

  /// The web-specific title of the notification.
  JsonString titleWeb = JsonString("titleWeb");

  /// The mobile-specific title of the notification.
  JsonString titleMobile = JsonString("titleMobile");

  /// The content of the notification.
  JsonString content = JsonString("content");

  /// The web-specific content of the notification.
  JsonString contentWeb = JsonString("contentWeb");

  /// The mobile-specific content of the notification.
  JsonString contentMobile = JsonString("contentMobile");

  /// The link associated with the notification.
  JsonString link = JsonString("link");

  /// The web-specific link associated with the notification.
  JsonString linkWeb = JsonString("linkWeb");

  /// The mobile-specific link associated with the notification.
  JsonString linkMobile = JsonString("linkMobile");

  /// The sender of the notification as an [AppUser].
  JsonObject<AppUser> sender = JsonObject<AppUser>("sender");

  /// The ID of the sender.
  JsonInteger senderId = JsonInteger("senderId");

  /// The recipient of the notification as an [AppUser].
  JsonObject<AppUser> recipient = JsonObject<AppUser>("recipient");

  /// The ID of the recipient.
  JsonInteger recipientId = JsonInteger("recipientId");

  /// Indicates if the notification is unread.
  JsonBoolean unread = JsonBoolean("unread");

  /// List of JSON fields representing the notification attributes.
  @override
  List<JsonField> get fields => [
        id,
        title,
        titleWeb,
        titleMobile,
        content,
        contentWeb,
        contentMobile,
        link,
        linkWeb,
        linkMobile,
        sender,
        senderId,
        recipient,
        recipientId,
        unread,
      ];
}
