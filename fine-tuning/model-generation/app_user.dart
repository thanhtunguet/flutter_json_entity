import 'package:supa_architecture/supa_architecture.dart';

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

  JsonInteger id = JsonInteger('id');

  JsonString code = JsonString('code');

  JsonString name = JsonString('name');

  JsonString birthday = JsonString('birthday');

  JsonObject<AppUser> supervisor = JsonObject<AppUser>('supervisor');

  JsonList<AppUser> students = JsonList<AppUser>('students');
}
