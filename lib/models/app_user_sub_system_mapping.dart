import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/models/app_user.dart';
import 'package:supa_architecture/models/sub_system.dart';

class AppUserSubSystemMapping extends JsonModel {
  JsonObject<AppUser> appUser = JsonObject<AppUser>("appUser");

  JsonInteger appUserId = JsonInteger("appUserId");

  JsonInteger subSystemId = JsonInteger("subSystemId");

  JsonObject<SubSystem> subSystem = JsonObject<SubSystem>("subSystem");

  JsonBoolean isAdmin = JsonBoolean("isAdmin");

  JsonBoolean isDefault = JsonBoolean("isDefault");

  JsonInteger statusId = JsonInteger("statusId");

  @override
  List<JsonField> get fields => [
        appUser,
        appUserId,
        subSystemId,
        subSystem,
        isAdmin,
        isDefault,
        statusId
      ];
}
