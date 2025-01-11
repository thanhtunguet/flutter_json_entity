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
      "X-Device-Name": deviceInfo.deviceModel,
      "X-Operating-System": deviceInfo.operatingSystem,
      "X-System-Version": deviceInfo.systemVersion,
      "X-Device-UUID": deviceInfo.deviceUuid,
    });

    // Pass the modified request to the next handler.
    handler.next(options);
  }
}
