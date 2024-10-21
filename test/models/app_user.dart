import 'package:injectable/injectable.dart';
import 'package:supa_architecture/json/json.dart';

@injectable
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

  JsonInteger id = JsonInteger("id");

  JsonString code = JsonString("code");

  JsonString name = JsonString("name");

  JsonDate birthday = JsonDate("birthday");

  JsonObject<AppUser> supervisor = JsonObject("supervisor");

  JsonList<AppUser> students = JsonList("students");
}
