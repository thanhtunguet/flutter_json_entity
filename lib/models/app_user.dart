import "package:supa_architecture/supa_architecture.dart";

/// A class representing an application user.
///
/// This class extends [JsonModel] and provides various fields representing
/// user attributes such as ID, email, username, and more. It also provides
/// a static instance of an empty [AppUser].
class AppUser extends JsonModel {
  /// A static instance of an empty [AppUser].
  static final AppUser empty = AppUser();

  /// List of JSON fields representing the user attributes.
  @override
  List<JsonField> get fields => [
        id,
        globalUserId,
        email,
        username,
        password,
        displayName,
        phone,
        address,
        dateOfBirth,
        avatar,
        adminType,
        adminTypeId,
        gender,
        genderId,
        isAlreadyGettingStarted,
        otpCode,
        language,
        languageId,
        createdAt,
        updatedAt,
        receivingSystemEmail,
        receivingSystemNotification,
        timezone,
        timezoneId,
        identityCode,
      ];

  /// The user ID.
  JsonInteger id = JsonInteger("id");

  /// The global user ID.
  JsonInteger globalUserId = JsonInteger("globalUserId");

  /// The user"s email address.
  JsonString email = JsonString("email");

  /// The user"s username.
  JsonString username = JsonString("username");

  /// The user"s password.
  JsonString password = JsonString("password");

  /// The user"s display name.
  JsonString displayName = JsonString("displayName");

  /// The user"s phone number.
  JsonString phone = JsonString("phone");

  /// The user"s address.
  JsonString address = JsonString("address");

  /// The user"s date of birth.
  JsonDate dateOfBirth = JsonDate("dateOfBirth");

  /// The user"s avatar URL.
  JsonString avatar = JsonString("avatar");

  /// The user"s admin type as an [EnumModel].
  JsonObject<EnumModel> adminType = JsonObject<EnumModel>("adminType");

  /// The ID of the user"s admin type.
  JsonInteger adminTypeId = JsonInteger("adminTypeId");

  /// The user"s gender as an [EnumModel].
  JsonObject<EnumModel> gender = JsonObject<EnumModel>("gender");

  /// The ID of the user"s gender.
  JsonInteger genderId = JsonInteger("genderId");

  /// Indicates if the user has already gotten started.
  JsonBoolean isAlreadyGettingStarted = JsonBoolean("isAlreadyGettingStarted");

  /// The OTP code for the user.
  JsonString otpCode = JsonString("otpCode");

  /// The user"s language as an [EnumModel].
  JsonObject<EnumModel> language = JsonObject<EnumModel>("language");

  /// The ID of the user"s language.
  JsonInteger languageId = JsonInteger("languageId");

  /// Indicates if the user is receiving system emails.
  JsonBoolean receivingSystemEmail = JsonBoolean("receivingSystemEmail");

  /// Indicates if the user is receiving system notifications.
  JsonBoolean receivingSystemNotification =
      JsonBoolean("receivingSystemNotification");

  /// The user"s timezone as an [EnumModel].
  JsonObject<EnumModel> timezone = JsonObject<EnumModel>("timezone");

  /// The ID of the user"s timezone.
  JsonInteger timezoneId = JsonInteger("timezoneId");

  /// The date the user was created.
  JsonDate createdAt = JsonDate("createdAt");

  /// The date the user was last updated.
  JsonDate updatedAt = JsonDate("updatedAt");

  /// The user"s identity code.
  JsonString identityCode = JsonString("identityCode");
}
