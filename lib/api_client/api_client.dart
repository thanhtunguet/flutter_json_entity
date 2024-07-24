import 'dart:async';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:supa_architecture/repositories/portal_authentication_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'http_response.dart';

/// An abstract class representing a client for interacting with an API.
///
/// This class provides methods for making HTTP requests, handling token refresh
/// operations, and downloading files. It uses the [Dio] package for HTTP
/// requests and includes custom interceptors for error handling and token
/// refreshing.
///
/// The [ApiClient] constructor sets up the base URL for requests and adds
/// interceptors for managing cookies and refreshing tokens.
///
/// **Usage Example:**
/// ```dart
/// class MyApiClient extends ApiClient {
///   @override
///   String get baseUrl => "https://api.example.com";
/// }
/// ```
abstract class ApiClient {
  static Completer<void>? _refreshCompleter;

  /// An interceptor for handling HTTP errors and refreshing tokens.
  ///
  /// If a 401 Unauthorized error occurs, this interceptor will attempt to
  /// refresh the token and retry the original request. It manages the token
  /// refresh operation to ensure that concurrent requests do not trigger
  /// multiple refresh operations.
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

  /// The [Dio] instance used for making HTTP requests.
  final Dio dio;

  /// Creates an instance of [ApiClient] and initializes the [Dio] instance.
  /// Sets up the base URL and adds interceptors for managing cookies and
  /// refreshing tokens.
  ApiClient() : dio = Dio() {
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(cookieStorageService.getCookieManager());
    dio.interceptors.add(refreshInterceptor);
  }

  /// The base URL for the API requests.
  String get baseUrl;

  /// Downloads the content from the specified URL as a [Uint8List].
  ///
  /// **Parameters:**
  /// - `url`: The URL from which to download the content.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the downloaded content as a [Uint8List].
  Future<Uint8List> downloadBytes(String url) {
    final options = Options(
      responseType: ResponseType.bytes,
    );
    return dio.get(url, options: options).then((response) => response.data);
  }

  /// Downloads the content from the specified URL and saves it to a file.
  ///
  /// **Parameters:**
  /// - `url`: The URL from which to download the content.
  /// - `savePath`: The directory path where the file should be saved.
  /// - `filename`: The name of the file to be saved.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the [io.File] if the download is successful;
  ///   otherwise, `null`.
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

  /// Refreshes the authentication token.
  ///
  /// This method is used by the refresh interceptor to obtain a new token
  /// when the current token has expired.
  ///
  /// **Returns:**
  /// - A [Future] that completes when the token refresh operation is finished.
  static Future<void> refreshToken() async {
    return PortalAuthenticationRepository().refreshToken();
  }
}
