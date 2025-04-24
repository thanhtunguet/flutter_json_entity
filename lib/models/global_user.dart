import 'package:supa_architecture/json/json.dart';

class GlobalUser extends JsonModel {
  @override
  List<JsonField> get fields => [
        id,
        userId,
        globalUserTypeId,
        businessPartnerId,
        username,
        displayName,
        email,
        phone,
        avatar,
        statusId,
        createdAt,
        updatedAt,
        rowId,
        tenantId,
      ];

  JsonInteger id = JsonInteger('id');
  JsonInteger userId = JsonInteger('userId');
  JsonInteger globalUserTypeId = JsonInteger('globalUserTypeId');
  JsonInteger businessPartnerId = JsonInteger('businessPartnerId');
  JsonString username = JsonString('username');
  JsonString displayName = JsonString('displayName');
  JsonString email = JsonString('email');
  JsonString phone = JsonString('phone');
  JsonString avatar = JsonString('avatar');
  JsonInteger statusId = JsonInteger('statusId');
  JsonDate createdAt = JsonDate('createdAt');
  JsonDate updatedAt = JsonDate('updatedAt');
  JsonInteger rowId = JsonInteger('rowId');
  JsonInteger tenantId = JsonInteger('tenantId');
}
