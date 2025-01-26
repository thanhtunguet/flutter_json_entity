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

    // Calculate hours and minutes
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs().remainder(60);

    // Format the offset based on whether minutes are non-zero
    if (minutes == 0) {
      return "$hours"; // No sign and no decimal part if the offset is an integer
    } else {
      final offsetDecimal = hours + (minutes / 60.0);
      return offsetDecimal
          .toStringAsFixed(2); // Decimal part only for non-integer offsets
    }
  }
}
