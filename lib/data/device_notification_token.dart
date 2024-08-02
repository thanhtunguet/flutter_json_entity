import 'package:equatable/equatable.dart';

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

  /// The notification token.
  final String? token;

  /// Constructs an instance of [DeviceNotificationToken].
  ///
  /// **Parameters:**
  /// - `osVersion`: The OS version of the device.
  /// - `deviceModel`: The model of the device.
  /// - `token`: The notification token (optional).
  const DeviceNotificationToken({
    required this.osVersion,
    required this.deviceModel,
    this.token,
  });

  /// Constructs an instance of [DeviceNotificationToken] from a JSON map.
  ///
  /// **Parameters:**
  /// - `json`: The JSON map containing the token data.
  DeviceNotificationToken.fromJSON(Map<String, dynamic> json)
      : osVersion = json['osVersion'],
        deviceModel = json['deviceModel'],
        token = json['token'];

  /// Converts the [DeviceNotificationToken] instance to a JSON map.
  ///
  /// **Returns:**
  /// - A JSON map containing the token data.
  Map<String, dynamic> toJSON() {
    return {
      'osVersion': osVersion,
      'deviceModel': deviceModel,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [
        osVersion,
        deviceModel,
        token,
      ];
}
