import 'package:get_it/get_it.dart';
import 'package:supa_architecture/supa_architecture.dart';

export 'base_repository.dart';
export 'portal_authentication_repository.dart';
export 'portal_profile_repository.dart';
export 'portal_tenant_repository.dart';
export 'utils_notification_repository.dart';

void registerRepositories() {
  GetIt.instance.registerSingleton<PortalAuthenticationRepository>(
      PortalAuthenticationRepository());
  GetIt.instance
      .registerSingleton<PortalProfileRepository>(PortalProfileRepository());
  GetIt.instance
      .registerSingleton<PortalTenantRepository>(PortalTenantRepository());
  GetIt.instance.registerSingleton<UtilsNotificationRepository>(
      UtilsNotificationRepository());
}
