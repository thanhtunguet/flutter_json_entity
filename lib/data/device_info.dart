import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  // Common properties
  final String deviceName;
  final String deviceModel;
  final String operatingSystem;
  final String systemVersion;

  // Constructor
  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.operatingSystem,
    required this.systemVersion,
  });

  // Method to get device info
  static Future<DeviceInfo> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final BaseDeviceInfo deviceInfoPlatform = await deviceInfo.deviceInfo;

    if (deviceInfoPlatform is AndroidDeviceInfo) {
      // Android-specific info
      final androidInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        deviceName: androidInfo.brand,
        deviceModel: androidInfo.model,
        operatingSystem: 'Android',
        systemVersion: androidInfo.version.release,
      );
    } else if (deviceInfoPlatform is IosDeviceInfo) {
      // iOS-specific info
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInfo(
        deviceName: iosInfo.name,
        deviceModel: iosInfo.model,
        operatingSystem: 'iOS',
        systemVersion: iosInfo.systemVersion,
      );
    } else {
      // Unknown platform
      return DeviceInfo(
        deviceName: 'Unknown',
        deviceModel: 'Unknown',
        operatingSystem: 'Unknown',
        systemVersion: 'Unknown',
      );
    }
  }
}
