import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";

/// Prints colored text to the console in debug mode.
///
/// The `color` parameter specifies the text color. Supported colors:
/// - "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white".
/// Defaults to no color if an invalid color is provided.
void _printColored(String text, String color) {
  const colorCodes = {
    "black": "\x1B[30m",
    "red": "\x1B[31m",
    "green": "\x1B[32m",
    "yellow": "\x1B[33m",
    "blue": "\x1B[34m",
    "magenta": "\x1B[35m",
    "cyan": "\x1B[36m",
    "white": "\x1B[37m"
  };

  const resetColor = "\x1B[0m";
  final colorCode = colorCodes[color] ?? resetColor;

  if (kDebugMode) {
    debugPrint("$colorCode$text$resetColor");
  }
}

/// An interceptor for logging HTTP errors with detailed color-coded messages.
///
/// This interceptor handles and logs HTTP errors with specific status codes,
/// providing clear visual feedback in the console.
///
/// Supported status codes:
/// - `500`: Internal Server Error
/// - `502`: Bad Gateway
/// - `503`: Service Unavailable
/// - `400`: Bad Request (logs specific error details if available)
/// - `403`: Forbidden
class GeneralErrorLogInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Extract relevant information from the error.
    final uri = err.requestOptions.uri.toString();
    final statusCode = err.response?.statusCode;

    // Log based on status codes.
    switch (statusCode) {
      case 500:
        _logError("INTERNAL_SERVER_ERROR", 500, uri, "red");
        break;

      case 502:
        _logError("BAD_GATEWAY", 502, uri, "red");
        break;

      case 503:
        _logError("SERVICE_UNAVAILABLE", 503, uri, "red");
        break;

      case 400:
        _logBadRequest(err);
        break;

      case 403:
        _logError("REQUEST_FORBIDDEN", 403, uri, "red");
        break;

      default:
        _printColored(
          "DIO ERROR ${statusCode ?? "UNKNOWN"} = $uri",
          "yellow",
        );
        break;
    }

    // Pass the error to the next handler in the chain.
    handler.next(err);
  }

  /// Logs an error message with a specific status code and color.
  void _logError(String label, int statusCode, String uri, String color) {
    _printColored("DIO $label $statusCode = $uri", color);
  }

  /// Handles and logs details for Bad Request (400) errors.
  void _logBadRequest(DioException err) {
    final uri = err.requestOptions.uri.toString();
    final data = err.response?.data;

    if (data is Map && data.containsKey("errors")) {
      final errors = jsonEncode(data["errors"]);
      _printColored("DIO BAD_REQUEST 400 = $errors", "red");
    } else {
      _printColored("DIO BAD_REQUEST 400 = $uri", "red");
    }
  }
}
