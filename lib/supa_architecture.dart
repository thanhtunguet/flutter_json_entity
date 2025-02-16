library supa_architecture;

import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';

import 'supa_architecture_platform_interface.dart';

export 'api_client/api_client.dart';
export 'blocs/blocs.dart';
export 'constants/constants.dart';
export 'exceptions/exceptions.dart';
export 'extensions/extensions.dart';
export 'filters/filters.dart';
export 'forms/forms.dart';
export 'json/json.dart';
export 'models/models.dart';
export 'providers/providers.dart';
export 'repositories/repositories.dart';
export 'services/services.dart';
export 'widgets/widgets.dart';

class SupaArchitecture {
  Future<String?> getPlatformVersion() {
    return SupaArchitecturePlatform.instance.getPlatformVersion();
  }
}

PersistentStorage get persistentStorage =>
    SupaArchitecturePlatform.instance.persistentStorage;

CookieManager get cookieManager =>
    SupaArchitecturePlatform.instance.cookieStorage;
