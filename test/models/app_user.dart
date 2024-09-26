import 'package:supa_architecture/json/json.dart';

class AppUser extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
        birthday,
        supervisor,
        students,
      ];

  JsonNumber id = JsonNumber("id");

  JsonString code = JsonString("code");

  JsonString name = JsonString("name");

  JsonDate birthday = JsonDate("birthday");

  JsonObject<AppUser> supervisor = JsonObject("supervisor");

  JsonList<AppUser> students = JsonList("students");
}
