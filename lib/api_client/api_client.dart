import 'dart:async';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'http_response.dart';

abstract class ApiClient {
  static Completer<void>? _refreshCompleter;

  static final refreshInterceptor = InterceptorsWrapper(
    onError: (DioException error, ErrorInterceptorHandler handler) async {
      if (error.response?.statusCode == 401) {
        if (_refreshCompleter == null) {
          _refreshCompleter = Completer<void>();
          try {
            await refreshToken();
            _refreshCompleter?.complete();
          } catch (refreshError) {
            _refreshCompleter?.completeError(refreshError);
          } finally {
            _refreshCompleter = null;
          }
        }

        try {
          await _refreshCompleter?.future;
          final dio = Dio();
          dio.interceptors.add(cookieStorageService.getCookieManager());
          final response = await dio.fetch(error.requestOptions);
          GetIt.instance.get<AuthenticationBloc>().handleLogout();
          return handler.resolve(response);
        } catch (refreshError) {
          return handler.next(error);
        }
      } else {
        return handler.next(error);
      }
    },
  );

  final Dio dio;

  ApiClient() : dio = Dio() {
    dio.options.baseUrl = baseUrl;
    final cookieManager =
        SupaApplication.instance.cookieStorageService.getCookieManager();
    dio.interceptors.add(cookieManager);
    dio.interceptors.add(refreshInterceptor);
    if (kDebugMode && io.Platform.isAndroid) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 100,
        ),
      );
    }
  }

  String get baseUrl;

  Future<Uint8List> downloadBytes(String url) {
    final options = Options(
      responseType: ResponseType.bytes,
    );
    return dio.get(url, options: options).then((response) => response.data);
  }

  Future<io.File?> downloadFile(
    String url, {
    required String savePath,
    required String filename,
  }) async {
    final directory = io.Directory(savePath);
    final filePath = join(directory.path, filename);
    try {
      final response = await dio.download(url, filePath);
      if (response.statusCode == 200) {
        return io.File(filePath);
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  static Future<void> refreshToken() async {
    return await PortalAuthenticationRepository()
        .refreshToken()
        .catchError((error) {
      throw error;
    });
  }
}
