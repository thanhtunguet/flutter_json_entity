import 'package:supa_architecture/json/json.dart';

class SubSystem extends JsonModel {
  JsonInteger id = JsonInteger('id');

  JsonString code = JsonString('code');

  JsonString name = JsonString('name');

  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
      ];
}
