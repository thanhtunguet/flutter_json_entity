import 'package:supa_architecture/json/json.dart';

/// A class representing a file model.
///
/// This class extends [JsonModel] and provides various fields representing
/// attributes of the file such as ID, name, path, URL, MIME type, size,
/// creation date, and update date.
class File extends JsonModel {
  /// List of JSON fields representing the file attributes.
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

  /// The ID of the file.
  JsonNumber id = JsonNumber("id");

  /// The name of the file.
  JsonString name = JsonString("name");

  /// The path of the file.
  JsonString path = JsonString("path");

  /// The URL of the file.
  JsonString url = JsonString("url");

  /// The MIME type of the file.
  JsonString mimeType = JsonString("mimeType");

  /// The size of the file.
  JsonNumber size = JsonNumber("size");

  /// The creation date of the file.
  JsonDate createdAt = JsonDate("createdAt");

  /// The last update date of the file.
  JsonDate updatedAt = JsonDate("updatedAt");
}
