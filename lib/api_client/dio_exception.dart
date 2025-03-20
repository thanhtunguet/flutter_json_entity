part of 'api_client.dart';

extension SupaDioException on DioException {
  bool get isForbidden {
    return response?.statusCode == 403;
  }

  bool get isNotFound {
    return response?.statusCode == 404;
  }

  bool get isUnauthorized {
    return response?.statusCode == 401;
  }

  bool get isBadRequest {
    return response?.statusCode == 400;
  }
}
