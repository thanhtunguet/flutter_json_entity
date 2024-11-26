import 'package:flutter_test/flutter_test.dart';
import 'package:supa_architecture/supa_architecture_method_channel.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

void main() {
  final SupaArchitecturePlatform initialPlatform =
      SupaArchitecturePlatform.instance;

  test('$MethodChannelSupaArchitecture is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSupaArchitecture>());
  });

  test('getPlatformVersion', () async {});
}
