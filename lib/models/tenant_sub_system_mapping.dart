import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/models/sub_system.dart';
import 'package:supa_architecture/models/tenant.dart';

class TenantSubSystemMapping extends JsonModel {
  JsonInteger tenantId = JsonInteger('tenantId');

  JsonInteger subsystemId = JsonInteger('subsystemId');

  JsonObject<Tenant> tenant = JsonObject('tenant');

  JsonObject<SubSystem> subSystem = JsonObject<SubSystem>('subsystem');

  @override
  List<JsonField> get fields => [
        tenantId,
        subsystemId,
        tenant,
        subSystem,
      ];
}
