import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_architecture/core/cookie_manager/basic_cookie_manager.dart';
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

  /// Constructor that initializes cookie storage immediately
  MethodChannelSupaArchitecture() {
    // Initialize with basic cookie manager immediately, then upgrade to Hive
    cookieStorage = BasicCookieManager();
    _initializeCookieStorage();
  }

  /// Initialize cookie storage asynchronously
  Future<void> _initializeCookieStorage() async {
    try {
      final hiveManager = await HiveCookieManager.create();
      // Upgrade to Hive cookie manager
      cookieStorage = hiveManager;
    } catch (e) {
      // Keep using basic implementation if Hive fails
      // ignore: avoid_print
      print('Failed to initialize HiveCookieManager: $e');
    }
  }

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
  }) async {
    super.initialize(
      useFirebase: useFirebase,
    );
    secureStorage.initialize();
    await persistentStorage.initialize();
  }
}
