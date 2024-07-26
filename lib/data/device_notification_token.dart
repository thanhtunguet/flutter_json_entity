import 'package:equatable/equatable.dart';

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
}
