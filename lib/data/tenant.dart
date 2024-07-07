import 'package:supa_architecture/supa_architecture.dart';

class Tenant extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        name,
        defaultPath,
        ownerId,
        isAlreadyGettingStarted,
        isOwner,
        tenantStatusId,
        tenantStatus,
        requestProperty,
      ];

  JsonNumber id = JsonNumber('id');

  JsonString name = JsonString('name');

  JsonString defaultPath = JsonString('defaultPath');

  JsonNumber ownerId = JsonNumber('ownerId');

  JsonBoolean isAlreadyGettingStarted = JsonBoolean('isAlreadyGettingStarted');

  JsonBoolean isOwner = JsonBoolean('isOwner');

  JsonNumber tenantStatusId = JsonNumber('tenantStatusId');

  JsonObject<EnumModel> tenantStatus = JsonObject<EnumModel>(
    'tenantStatus',
    EnumModel.new,
  );

  JsonString requestProperty = JsonString('requestProperty');
}
