import "package:equatable/equatable.dart";

/// A class representing a device notification token.
///
/// This class extends [Equatable] for value comparison and provides
/// properties for the OS version, device model, and notification token. It
/// also includes methods for JSON serialization and deserialization.
class DeviceNotificationToken extends Equatable {
  /// The OS version of the device.
  final String osVersion;

  /// The model of the device.
  final String deviceModel;

  /// The device ID.
  final String deviceId;

  /// The notification token.
  final String? token;

  /// The subsystem ID.
  final int? subSystemId;

  /// The app code.
  final String appCode;

  /// Constructs an instance of [DeviceNotificationToken].
  ///
  /// **Parameters:**
  /// - `osVersion`: The OS version of the device.
  /// - `deviceModel`: The model of the device.
  /// - `token`: The notification token (optional).
  const DeviceNotificationToken({
    required this.osVersion,
    required this.deviceId,
    required this.deviceModel,
    required this.appCode,
    this.token,
    this.subSystemId,
  });

  /// Constructs an instance of [DeviceNotificationToken] from a JSON map.
  ///
  /// **Parameters:**
  /// - `json`: The JSON map containing the token data.
  DeviceNotificationToken.fromJson(Map<String, dynamic> json)
      : osVersion = json["osVersion"],
        deviceId = json["deviceId"],
        deviceModel = json["deviceModel"],
        token = json["token"],
        appCode = json["appCode"],
        subSystemId = int.tryParse(json["subSystemId"]);

  /// Converts the [DeviceNotificationToken] instance to a JSON map.
  ///
  /// **Returns:**
  /// - A JSON map containing the token data.
  Map<String, dynamic> toJson() {
    return {
      "osVersion": osVersion,
      "deviceId": deviceId,
      "deviceModel": deviceModel,
      "token": token,
      "appCode": appCode,
      "subSystemId": subSystemId,
    };
  }

  @override
  List<Object?> get props => [
        osVersion,
        deviceId,
        deviceModel,
        token,
        subSystemId,
        appCode,
      ];
}
