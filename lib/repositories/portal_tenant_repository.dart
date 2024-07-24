import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/data/tenant_filter.dart';
import 'package:supa_architecture/supa_architecture.dart';

class PortalTenantRepository extends BaseRepository<Tenant, TenantFilter> {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(path: '/rpc/portal/mobile/authentication')
      .toString();

  @override
  Future<List<Tenant>> list(TenantFilter filter) async {
    return dio
        .post(
          '/list-tenant',
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<Tenant>(),
        );
  }

  @override
  Future<int> count(TenantFilter filter) async {
    return dio
        .post(
          '/count-tenant',
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }
}
