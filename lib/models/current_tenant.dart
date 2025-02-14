import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/models/app_user.dart';
import 'package:supa_architecture/models/tenant.dart';

class CurrentTenant extends Tenant {
  @override
  List<JsonField> get fields => [
        ...super.fields,
        appUser,
      ];

  JsonObject<AppUser> appUser = JsonObject<AppUser>("appUser");
}
