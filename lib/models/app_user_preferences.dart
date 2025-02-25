import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/models/enum_model.dart';

mixin AppUserPreferences {
  List<JsonField> get preferenceFields => [
        adminType,
        adminTypeId,
        gender,
        genderId,
        language,
        languageId,
        receivingSystemEmail,
        receivingSystemNotification,
        timezone,
        timezoneId,
      ];

  /// The user's admin type as an [EnumModel].
  JsonObject<EnumModel> adminType = JsonObject<EnumModel>("adminType");

  /// The ID of the user's admin type.
  JsonInteger adminTypeId = JsonInteger("adminTypeId");

  /// The user's gender as an [EnumModel].
  JsonObject<EnumModel> gender = JsonObject<EnumModel>("gender");

  /// The ID of the user's gender.
  JsonInteger genderId = JsonInteger("genderId");

  /// The user's language as an [EnumModel].
  JsonObject<EnumModel> language = JsonObject<EnumModel>("language");

  /// The ID of the user's language.
  JsonInteger languageId = JsonInteger("languageId");

  /// Indicates if the user is receiving system emails.
  JsonBoolean receivingSystemEmail = JsonBoolean("receivingSystemEmail");

  /// Indicates if the user is receiving system notifications.
  JsonBoolean receivingSystemNotification =
      JsonBoolean("receivingSystemNotification");

  /// The user's timezone as an [EnumModel].
  JsonObject<EnumModel> timezone = JsonObject<EnumModel>("timezone");

  /// The ID of the user's timezone.
  JsonInteger timezoneId = JsonInteger("timezoneId");
}
