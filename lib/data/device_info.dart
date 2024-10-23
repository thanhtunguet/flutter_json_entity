import "package:device_info_plus/device_info_plus.dart";

/// A class representing device information.
///
/// This class provides common properties for device information such as
/// device name, device model, operating system, and system version. It also
/// includes a static method to asynchronously fetch device information
/// based on the platform (Android or iOS).
class DeviceInfo {
  /// The name of the device.
  final String deviceName;

  /// The model of the device.
  final String deviceModel;

  /// The operating system of the device.
  final String operatingSystem;

  /// The system version of the device.
  final String systemVersion;

  /// The UUID of the device.
  final String deviceUuid;

  /// Constructs an instance of [DeviceInfo].
  ///
  /// **Parameters:**
  /// - `deviceName`: The name of the device.
  /// - `deviceModel`: The model of the device.
  /// - `operatingSystem`: The operating system of the device.
  /// - `systemVersion`: The system version of the device.
  DeviceInfo({
    required this.deviceName,
    required this.deviceModel,
    required this.operatingSystem,
    required this.systemVersion,
    required this.deviceUuid,
  });

  /// Asynchronously fetches the device information.
  ///
  /// This method retrieves device information using the [DeviceInfoPlugin]
  /// and returns an instance of [DeviceInfo] with the appropriate details
  /// based on the platform (Android or iOS).
  ///
  /// **Returns:**
  /// - A [Future] that resolves to an instance of [DeviceInfo].
  static Future<DeviceInfo> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final BaseDeviceInfo deviceInfoPlatform = await deviceInfo.deviceInfo;

    if (deviceInfoPlatform is AndroidDeviceInfo) {
      // Android-specific info
      final androidInfo = await deviceInfo.androidInfo;
      return DeviceInfo(
        deviceName: androidInfo.brand,
        deviceModel: androidInfo.model,
        operatingSystem: "Android",
        systemVersion: androidInfo.version.release,
        deviceUuid: androidInfo.serialNumber,
      );
    } else if (deviceInfoPlatform is IosDeviceInfo) {
      // iOS-specific info
      final iosInfo = await deviceInfo.iosInfo;
      return DeviceInfo(
        deviceName: iosInfo.name,
        deviceModel: iosInfo.model,
        operatingSystem: "iOS",
        systemVersion: iosInfo.systemVersion,
        deviceUuid: iosInfo.identifierForVendor ?? iosInfo.utsname.machine,
      );
    } else {
      // Unknown platform
      return DeviceInfo(
        deviceName: "Unknown",
        deviceModel: "Unknown",
        operatingSystem: "Unknown",
        systemVersion: "Unknown",
        deviceUuid: "Unknown",
      );
    }
  }
}
