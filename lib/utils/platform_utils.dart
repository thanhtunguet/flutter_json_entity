import 'dart:io';

class PlatformUtils {
  static T select<T>({
    T? android,
    T? ios,
    T? macos,
    T? windows,
    T? linux,
    T? fuchsia,
    required T fallback,
  }) {
    if (Platform.isAndroid && android != null) return android;
    if (Platform.isIOS && ios != null) return ios;
    if (Platform.isMacOS && macos != null) return macos;
    if (Platform.isWindows && windows != null) return windows;
    if (Platform.isLinux && linux != null) return linux;
    if (Platform.isFuchsia && fuchsia != null) return fuchsia;
    return fallback; // Fallback if no platform-specific value is provided
  }
}
