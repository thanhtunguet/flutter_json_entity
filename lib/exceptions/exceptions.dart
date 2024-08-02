import 'dart:io';

import 'package:dio/dio.dart';

/// A sealed class representing a custom exception in Supa.
///
/// This class extends [HttpException] and provides a factory method to create
/// specific exceptions based on Dio errors.
sealed class SupaException extends HttpException {
  /// Constructs an instance of [SupaException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaException(super.message);

  /// Creates a [SupaException] from a Dio error.
  ///
  /// **Parameters:**
  /// - `exception`: The Dio error to convert.
  ///
  /// **Returns:**
  /// - An instance of [SupaException] corresponding to the Dio error.
  static SupaException fromDio(Object exception) {
    if (exception is DioException && exception.response != null) {
      switch (exception.response!.statusCode) {
        case 401:
          return SupaUnauthorizedException('Thông tin đăng nhập hết hạn');

        case 404:
          return SupaNotFoundException(
            'Nội dung không tồn tại trên hệ thống',
          );

        case 400:
          return SupaNotFoundException(
              exception.response!.data['generalErrors'][0]);

        case 403:
          return SupaForbiddenException(
            'Bạn không có quyền truy cập vào nội dung này',
          );

        default:
          return SupaUnknownException(
            'Có lỗi xảy ra trong quá trình tải dữ liệu',
          );
      }
    }
    return SupaUnknownException(
      'Có lỗi xảy ra trong quá trình tải dữ liệu',
    );
  }
}

/// A class representing an unknown exception in Supa.
final class SupaUnknownException extends SupaException {
  /// Constructs an instance of [SupaUnknownException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaUnknownException(super.message);
}

/// A class representing a forbidden exception in Supa.
final class SupaForbiddenException extends SupaException {
  /// Constructs an instance of [SupaForbiddenException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaForbiddenException(super.message);
}

/// A class representing a not found exception in Supa.
final class SupaNotFoundException extends SupaException {
  /// Constructs an instance of [SupaNotFoundException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaNotFoundException(super.message);
}

/// A class representing a bad request exception in Supa.
final class SupaBadRequestException extends SupaException {
  /// Constructs an instance of [SupaBadRequestException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaBadRequestException(super.message);
}

/// A class representing an unauthorized exception in Supa.
final class SupaUnauthorizedException extends SupaException {
  /// Constructs an instance of [SupaUnauthorizedException].
  ///
  /// **Parameters:**
  /// - `message`: The error message.
  SupaUnauthorizedException(super.message);
}
