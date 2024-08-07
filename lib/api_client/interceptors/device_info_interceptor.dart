import 'package:dio/dio.dart';
import 'package:supa_architecture/supa_architecture.dart';

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

    options.headers['X-Device-Model'] = deviceInfo.deviceModel;
    options.headers['X-Device-Name'] = deviceInfo.deviceName;
    options.headers['X-Operating-System'] = deviceInfo.operatingSystem;
    options.headers['X-System-Version'] = deviceInfo.systemVersion;

    super.onRequest(options, handler);
  }
}
