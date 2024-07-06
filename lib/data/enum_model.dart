import 'package:supa_architecture/json/json.dart';

class EnumModel extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
        color,
      ];

  JsonNumber id = JsonNumber("id");

  JsonString code = JsonString("code");

  JsonString name = JsonString("name");

  JsonString color = JsonString("color");
}
