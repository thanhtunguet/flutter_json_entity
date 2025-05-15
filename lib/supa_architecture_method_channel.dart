import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/core/cookie_manager/hive_cookie_manager.dart';
import 'package:supa_architecture/core/persistent_storage/hive_persistent_storage.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/extensions/dotenv.dart';

import 'supa_architecture_platform_interface.dart';

/// An implementation of [SupaArchitecturePlatform] that uses method channels.
class MethodChannelSupaArchitecture extends SupaArchitecturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('supa_architecture');

  @override
  final PersistentStorage persistentStorage = HivePersistentStorage();

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  String getBaseUrl() {
    return dotenv.baseApiUrl;
  }

  @override
  bool get useFirebase => kIsWeb || (!Platform.isLinux && !Platform.isWindows);

  @override
  Future<void> initialize({
    bool useFirebase = false,
    bool useSentry = false,
  }) async {
    super.initialize(
      useFirebase: useFirebase,
      useSentry: useSentry,
    );
    cookieStorage = await HiveCookieManager.create();
    secureStorage.initialize();
    await persistentStorage.initialize();
  }
}
