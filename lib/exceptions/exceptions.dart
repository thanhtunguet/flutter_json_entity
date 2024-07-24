import 'dart:io';

import 'package:dio/dio.dart';

sealed class SupaException extends HttpException {
  SupaException(super.message);

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

final class SupaUnknownException extends SupaException {
  SupaUnknownException(super.message);
}

final class SupaForbiddenException extends SupaException {
  SupaForbiddenException(super.message);
}

final class SupaNotFoundException extends SupaException {
  SupaNotFoundException(super.message);
}

final class SupaBadRequestException extends SupaException {
  SupaBadRequestException(super.message);
}

final class SupaUnauthorizedException extends SupaException {
  SupaUnauthorizedException(super.message);
}
