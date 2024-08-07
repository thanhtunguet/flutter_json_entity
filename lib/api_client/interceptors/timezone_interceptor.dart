import 'package:dio/dio.dart';

/// A custom interceptor to add the `X-Timezone` header to every request.
/// The header value is the current timezone offset in decimal format.
class TimezoneInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the current timezone offset
    DateTime now = DateTime.now();
    Duration offset = now.timeZoneOffset;
    String sign = offset.isNegative ? '-' : '+';

    // Calculate the decimal value of the timezone offset
    double offsetDecimal =
        offset.inHours + (offset.inMinutes.remainder(60) / 60.0);
    String offsetString = '$sign${offsetDecimal.toStringAsFixed(2)}';

    // Add the `X-Timezone` header to the request
    options.headers['X-Timezone'] = offsetString;
    options.headers['X-RequestedAt'] = now.toIso8601String();

    // Continue with the request
    super.onRequest(options, handler);
  }
}
