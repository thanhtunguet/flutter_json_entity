import "package:dio/dio.dart";
import "package:supa_architecture/json/json.dart";

/// An interceptor to add timezone and request timestamp headers to every request.
///
/// Headers added:
/// - `X-Timezone`: Current timezone offset in decimal format (e.g., "+5.50").
/// - `X-Requested-At`: ISO 8601 formatted timestamp with timezone offset.
class TimezoneInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add the timezone and request timestamp headers
    options.headers["X-Timezone"] = _getTimezoneOffset();
    options.headers["X-Requested-At"] =
        DateTime.now().toIso8601StringWithOffset();

    // Continue the request chain
    handler.next(options);
  }

  /// Calculates the current timezone offset in decimal format (e.g., "+5.50").
  String _getTimezoneOffset() {
    final now = DateTime.now();
    final offset = now.timeZoneOffset;

    // Determine the sign of the offset
    final sign = offset.isNegative ? "-" : "+";

    // Calculate the offset in hours and minutes as a decimal
    final offsetDecimal =
        offset.inHours.abs() + (offset.inMinutes.abs().remainder(60) / 60.0);

    // Format the offset string with the appropriate sign
    return "$sign${offsetDecimal.toStringAsFixed(2)}";
  }
}
