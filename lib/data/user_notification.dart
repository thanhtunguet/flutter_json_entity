import 'package:supa_architecture/supa_architecture.dart';

class UserNotification extends JsonModel {
  JsonNumber id = JsonNumber("id");

  JsonString title = JsonString("title");
  JsonString titleWeb = JsonString("titleWeb");
  JsonString titleMobile = JsonString("titleMobile");

  JsonString content = JsonString("content");
  JsonString contentWeb = JsonString("contentWeb");
  JsonString contentMobile = JsonString("contentMobile");

  JsonString link = JsonString("link");
  JsonString linkWeb = JsonString("linkWeb");
  JsonString linkMobile = JsonString("linkMobile");

  JsonObject<AppUser> sender = JsonObject<AppUser>("sender", AppUser.new);
  JsonNumber senderId = JsonNumber("senderId");
  JsonObject<AppUser> recipient = JsonObject<AppUser>("recipient", AppUser.new);
  JsonNumber recipientId = JsonNumber("recipientId");

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
      ];
}
