import "package:dio/dio.dart";
import "package:supa_architecture/supa_architecture_platform_interface.dart";

/// An interceptor that adds device information headers to outgoing requests.
///
/// This interceptor is used to provide device-specific details for API calls,
/// helping the backend identify the source device.
class DeviceInfoInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Fetch device information from the platform interface.
    final deviceInfo = SupaArchitecturePlatform.instance.deviceInfo;

    // Add device-specific headers to the request.
    options.headers.addAll({
      "X-Device-Model": deviceInfo.deviceModel,
      "X-Device-Name": _sanitizeDeviceName(deviceInfo.deviceName),
      "X-Operating-System": deviceInfo.operatingSystem,
      "X-System-Version": deviceInfo.systemVersion,
      "X-Device-UUID": deviceInfo.deviceUuid,
    });

    // Pass the modified request to the next handler.
    handler.next(options);
  }

  /// Sanitizes the device name to ensure it adheres to API requirements.
  ///
  /// Removes special characters, trims unnecessary spaces, and limits the length.
  String _sanitizeDeviceName(String deviceName) {
    // Step-by-step sanitization process:
    return deviceName
        .trim() // Remove leading and trailing whitespace.
        .replaceAll(RegExp(r"[^\w\s-]"), "") // Remove special characters.
        .replaceAll(
            RegExp(r"\s+"), " ") // Consolidate multiple spaces into one.
        .substring(
            0,
            deviceName.length > 50
                ? 50
                : deviceName.length); // Limit length to 50 characters.
  }
}
