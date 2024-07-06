import 'package:equatable/equatable.dart';

class DeviceNotificationToken extends Equatable {
  @override
  List<Object?> get props => [
        globalUserId,
        osVersion,
        deviceModel,
        token,
      ];

  final int globalUserId;

  final String osVersion;

  final String deviceModel;

  final String? token;

  const DeviceNotificationToken({
    required this.globalUserId,
    required this.osVersion,
    required this.deviceModel,
    this.token,
  });

  DeviceNotificationToken.fromJSON(Map<String, dynamic> json)
      : globalUserId = json['globalUserId'],
        osVersion = json['osVersion'],
        deviceModel = json['deviceModel'],
        token = json['token'];

  Map<String, dynamic> toJSON() {
    return {
      'globalUserId': globalUserId,
      'osVersion': osVersion,
      'deviceModel': deviceModel,
      'token': token,
    };
  }
}
