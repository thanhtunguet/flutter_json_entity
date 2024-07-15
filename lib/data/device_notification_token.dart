import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  final String osVersion;

  final String deviceModel;

  const DeviceInfo({
    required this.osVersion,
    required this.deviceModel,
  });
}

class DeviceNotificationToken extends Equatable {
  @override
  List<Object?> get props => [
        osVersion,
        deviceModel,
        token,
      ];

  final String osVersion;

  final String deviceModel;

  final String? token;

  const DeviceNotificationToken({
    required this.osVersion,
    required this.deviceModel,
    this.token,
  });

  DeviceNotificationToken.fromJSON(Map<String, dynamic> json)
      : osVersion = json['osVersion'],
        deviceModel = json['deviceModel'],
        token = json['token'];

  Map<String, dynamic> toJSON() {
    return {
      'osVersion': osVersion,
      'deviceModel': deviceModel,
      'token': token,
    };
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String osVersion = 'Unknown';
    String deviceModel = 'Unknown';

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        osVersion = androidInfo.version.release;
        deviceModel = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        osVersion = iosInfo.systemVersion;
        deviceModel = iosInfo.model;
      } else if (kIsWeb) {
        WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
        osVersion = webInfo.userAgent ?? 'Unknown';
        deviceModel = webInfo.browserName.name;
      }
    } catch (e) {
      // Handle exception if needed
    }

    return DeviceInfo(
      deviceModel: deviceModel,
      osVersion: osVersion,
    );
  }
}
