import "package:dio/dio.dart";
import "package:supa_architecture/supa_architecture.dart";

/// An interceptor for adding device information headers to outgoing requests.
///
/// This interceptor adds the following headers to outgoing requests:
///
/// - `X-Device-Model`: The device model.
/// - `X-Device-Name`: The device name.
/// - `X-Operating-System`: The operating system.
/// - `X-System-Version`: The system version.
///
/// This interceptor is used to identify the device making the request in the
/// backend.
class DeviceInfoInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final deviceInfo = SupaApplication.instance.deviceInfo;

    options.headers["X-Device-Model"] = deviceInfo.deviceModel;
    options.headers["X-Device-Name"] =
        _sanitizeDeviceName(deviceInfo.deviceName);
    options.headers["X-Operating-System"] = deviceInfo.operatingSystem;
    options.headers["X-System-Version"] = deviceInfo.systemVersion;

    super.onRequest(options, handler);
  }

  String _sanitizeDeviceName(String deviceName) {
    // Remove leading and trailing whitespaces
    String sanitized = deviceName.trim();

    // Replace special characters with an empty string (keep letters, numbers, and spaces)
    sanitized = sanitized.replaceAll(RegExp(r"[^\w\s-]"), "");

    // Replace multiple spaces with a single space
    sanitized = sanitized.replaceAll(RegExp(r"\s+"), " ");

    // Limit the length to 50 characters (adjust the limit as necessary)
    if (sanitized.length > 50) {
      sanitized = sanitized.substring(0, 50);
    }

    return sanitized;
  }
}
