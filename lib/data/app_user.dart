import 'package:supa_architecture/json/json.dart';

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
        createdAt,
        updatedAt,
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

  JsonDate createdAt = JsonDate("createdAt");

  JsonDate updatedAt = JsonDate("updatedAt");
}
