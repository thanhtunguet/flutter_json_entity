import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

void _printColored(String text, String color) {
  final colorCodes = {
    'black': '\x1B[30m',
    'red': '\x1B[31m',
    'green': '\x1B[32m',
    'yellow': '\x1B[33m',
    'blue': '\x1B[34m',
    'magenta': '\x1B[35m',
    'cyan': '\x1B[36m',
    'white': '\x1B[37m'
  };

  const resetColor = '\x1B[0m';
  final colorCode = colorCodes[color] ?? resetColor;

  if (kDebugMode) {
    print('$colorCode$text$resetColor');
  }
}

/// An interceptor for logging general errors during HTTP requests.
///
/// This interceptor logs various types of errors that occur during HTTP
/// requests. It prints the error message and the request URL to the console in
/// different colors depending on the error status code.
///
/// The supported error status codes and their corresponding colors are:
///
/// - `403`: red
/// - Other status codes: yellow
///
/// This interceptor is used to provide a visible indication of errors that
/// occur during HTTP requests.
class GeneralErrorLogInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 403:
        _printColored(
          'DIO REQUEST_FORBIDDEN 403 = ${err.requestOptions.uri.toString()}',
          'red',
        );
        break;

      case 400:
        if (err.response?.data is Map) {
          final errors = err.response?.data['errors'];
          _printColored("DIO BAD_REQUEST 401 = ${jsonEncode(errors)}", 'red');
        }

        break;
    }
    super.onError(err, handler);
  }
}
