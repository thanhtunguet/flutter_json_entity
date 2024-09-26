import 'package:supa_architecture/data/app_user.dart';
import 'package:supa_architecture/data/file.dart';
import 'package:supa_architecture/json/json.dart';

/// An abstract class representing an attachment model.
///
/// The `Attachment` class defines the structure and fields for an attachment,
/// which can be a file or a link, along with associated metadata such as
/// description, creator information, and timestamps. It extends the `JsonModel`
/// class to facilitate JSON serialization and deserialization.
abstract class Attachment extends JsonModel {
  /// The unique identifier of the attachment.
  JsonNumber id = JsonNumber("id");

  /// A brief description of the attachment.
  JsonString description = JsonString("description");

  /// The name of the attachment.
  JsonString name = JsonString("name");

  /// Indicates whether the attachment is a file.
  ///
  /// - `true`: The attachment is a file.
  /// - `false`: The attachment is not a file (it might be a link).
  JsonBoolean isFile = JsonBoolean("isFile");

  /// The unique identifier of the associated file, if any.
  ///
  /// This field is used when the attachment is linked to a file stored in the system.
  JsonNumber fileId = JsonNumber("fileId");

  /// The URL or link associated with the attachment, if any.
  ///
  /// This field is used when the attachment is a link to external content.
  JsonString link = JsonString("link");

  /// The file path of the attachment, if any.
  ///
  /// This field stores the local or remote path to the file associated with the attachment.
  JsonString path = JsonString("path");

  /// The unique identifier of the user who created the attachment.
  JsonNumber appUserId = JsonNumber("appUserId");

  /// The user who created the attachment.
  ///
  /// This is a nested JSON object representing the `AppUser` who created the attachment.
  JsonObject<AppUser> appUser = JsonObject<AppUser>("appUser");

  /// The file associated with the attachment.
  ///
  /// This is a nested JSON object representing the `File` linked to the attachment.
  JsonObject<File> file = JsonObject<File>("file");

  /// The timestamp indicating when the attachment was created.
  JsonDate createdAt = JsonDate("createdAt");

  /// The timestamp indicating the last time the attachment was updated.
  JsonDate updatedAt = JsonDate("updatedAt");

  /// A list of all JSON fields included in the attachment model.
  ///
  /// This getter returns all the fields that should be serialized or deserialized
  /// when converting the attachment to or from JSON format.
  @override
  List<JsonField> get fields => [
        id,
        name,
        isFile,
        fileId,
        path,
        appUserId,
        appUser,
        file,
        link,
        description,
      ];
}
