import 'package:supa_architecture/supa_architecture.dart';

class AppUser extends JsonModel {
  static final AppUser empty = AppUser();

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
      ];

  JsonNumber id = JsonNumber("id");

  JsonNumber globalUserId = JsonNumber("globalUserId");

  JsonString email = JsonString("email");

  JsonString username = JsonString("username");

  JsonString password = JsonString("password");

  JsonString displayName = JsonString("displayName");

  JsonString phone = JsonString("phone");

  JsonString address = JsonString("address");

  JsonDate dateOfBirth = JsonDate("dateOfBirth");

  JsonString avatar = JsonString("avatar");

  JsonObject<EnumModel> adminType =
      JsonObject<EnumModel>("adminType", EnumModel.new);

  JsonNumber adminTypeId = JsonNumber("adminTypeId");

  JsonObject<EnumModel> gender = JsonObject<EnumModel>("gender", EnumModel.new);

  JsonNumber genderId = JsonNumber("genderId");

  JsonBoolean isAlreadyGettingStarted = JsonBoolean("isAlreadyGettingStarted");

  JsonString otpCode = JsonString("otpCode");

  JsonObject<EnumModel> language =
      JsonObject<EnumModel>("language", EnumModel.new);

  JsonNumber languageId = JsonNumber("languageId");

  JsonBoolean receivingSystemEmail = JsonBoolean("receivingSystemEmail");

  JsonBoolean receivingSystemNotification =
      JsonBoolean("receivingSystemNotification");

  JsonObject<EnumModel> timezone =
      JsonObject<EnumModel>("timezone", EnumModel.new);

  JsonNumber timezoneId = JsonNumber("timezoneId");

  JsonDate createdAt = JsonDate("createdAt");

  JsonDate updatedAt = JsonDate("updatedAt");

  JsonString identityCode = JsonString("identityCode");
}
