import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/enum_model.dart";

/// A class representing a tenant.
///
/// This class extends [JsonModel] and provides various fields representing
/// attributes of a tenant such as ID, code, name, default path, owner ID,
/// tenant status, and additional properties.
class Tenant extends JsonModel {
  /// List of JSON fields representing the tenant attributes.
  @override
  List<JsonField> get fields => [
        id,
        code,
        name,
        defaultPath,
        ownerId,
        isAlreadyGettingStarted,
        isOwner,
        tenantStatusId,
        tenantStatus,
        requestProperty,
        isCurrentTenant,
      ];

  /// The ID of the tenant.
  JsonInteger id = JsonInteger("id");

  /// The code of the tenant.
  JsonString code = JsonString("code");

  /// The name of the tenant.
  JsonString name = JsonString("name");

  /// The default path of the tenant.
  JsonString defaultPath = JsonString("defaultPath");

  /// The ID of the owner of the tenant.
  JsonInteger ownerId = JsonInteger("ownerId");

  /// Indicates if the tenant has already gotten started.
  JsonBoolean isAlreadyGettingStarted = JsonBoolean("isAlreadyGettingStarted");

  /// Indicates if the user is the owner of the tenant.
  JsonBoolean isOwner = JsonBoolean("isOwner");

  /// The ID of the tenant"s status.
  JsonInteger tenantStatusId = JsonInteger("tenantStatusId");

  /// The status of the tenant as an [EnumModel].
  JsonObject<EnumModel> tenantStatus = JsonObject<EnumModel>("tenantStatus");

  /// The request property of the tenant.
  JsonString requestProperty = JsonString("requestProperty");

  JsonBoolean isCurrentTenant = JsonBoolean("isCurrentTenant");
}
