import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class CookieStorageService {
  static Future<CookieStorageService> initialize() async {
    final documentsDir = await getApplicationCacheDirectory();

    PersistCookieJar persistCookieJar = PersistCookieJar(
      storage: FileStorage(documentsDir.path),
    );

    return _CookieStorageServiceImpl._(
      persistCookieJar: persistCookieJar,
    );
  }

  CookieManager getCookieManager();
}

class _CookieStorageServiceImpl implements CookieStorageService {
  final PersistCookieJar persistCookieJar;

  _CookieStorageServiceImpl._({
    required this.persistCookieJar,
  });

  @override
  CookieManager getCookieManager() {
    return CookieManager(persistCookieJar);
  }
}
