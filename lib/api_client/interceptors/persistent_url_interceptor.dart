import 'package:dio/dio.dart';
import 'package:supa_architecture/supa_architecture.dart';

class PersistentUrlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final baseUri = Uri.parse(options.baseUrl);
    final persistentUri = Uri.parse(persistentStorage.baseApiUrl);
    handler.next(options.copyWith(
      baseUrl: Uri.parse(options.baseUrl)
          .replace(
            host: persistentUri.host,
            path: baseUri.path,
          )
          .toString(),
    ));
  }
}
