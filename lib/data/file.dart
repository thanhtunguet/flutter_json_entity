import 'package:supa_architecture/json/json.dart';

class File extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        name,
        path,
        url,
        mimeType,
        size,
        createdAt,
        updatedAt,
      ];

  JsonNumber id = JsonNumber("id");

  JsonString name = JsonString("name");

  JsonString path = JsonString("path");

  JsonString url = JsonString("url");

  JsonString mimeType = JsonString("mimeType");

  JsonNumber size = JsonNumber("size");

  JsonDate createdAt = JsonDate("createdAt");

  JsonDate updatedAt = JsonDate("updatedAt");
}
