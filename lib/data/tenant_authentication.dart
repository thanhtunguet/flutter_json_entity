import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/supa_architecture.dart';

class TenantAuthentication {
  final Tenant tenant;

  final AppUser appUser;

  TenantAuthentication(this.tenant, this.appUser);
}
