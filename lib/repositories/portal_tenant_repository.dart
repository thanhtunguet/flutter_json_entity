import 'package:supa_architecture/data/tenant.dart';
import 'package:supa_architecture/data/tenant_filter.dart';
import 'package:supa_architecture/supa_architecture.dart';

/// A repository class for managing tenants.
///
/// This class extends [BaseRepository] and provides methods for listing and
/// counting tenants based on the provided filters.
class PortalTenantRepository extends BaseRepository<Tenant, TenantFilter> {
  @override
  String get baseUrl => Uri.parse(persistentStorageService.baseApiUrl)
      .replace(path: '/rpc/portal/mobile/authentication')
      .toString();

  /// Lists tenants based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [TenantFilter] to filter the list of tenants.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of [Tenant]s.
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

  /// Counts tenants based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: The [TenantFilter] to filter the tenants.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of tenants.
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
