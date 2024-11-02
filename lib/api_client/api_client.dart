import "dart:async";
import "dart:io" as io;

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:path/path.dart" as path;
import "package:path/path.dart";
import "package:supa_architecture/api_client/interceptors/device_info_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/general_error_log_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/refresh_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/timezone_interceptor.dart";
import "package:supa_architecture/supa_architecture.dart";

part "http_response.dart";

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
  /// The [Dio] instance used for making HTTP requests.
  final Dio dio;

  /// Creates an instance of [ApiClient] and initializes the [Dio] instance.
  /// Sets up the base URL and adds interceptors for managing cookies and
  /// refreshing tokens.
  ApiClient() : dio = Dio() {
    dio.options.baseUrl = baseUrl;
    if (!kIsWeb) {
      dio.interceptors.add(cookieStorageService.getCookieManager());
    }
    dio.interceptors.add(DeviceInfoInterceptor());
    dio.interceptors.add(TimezoneInterceptor());
    dio.interceptors.add(RefreshInterceptor());
    dio.interceptors.add(GeneralErrorLogInterceptor());
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

  /// Uploads a file to the specified upload URL.
  ///
  /// **Parameters:**
  /// - `filePath`: The path to the file to be uploaded.
  /// - `uploadUrl`: The URL to which the file will be uploaded. Defaults to `/upload-file`.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a [File] object representing the uploaded file.
  Future<File> uploadFile({
    required String filePath,
    String uploadUrl = "/upload-file",
  }) async {
    String filename = path.basename(filePath);
    FormData formData = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(filePath, filename: filename),
      },
    );

    return dio.post(uploadUrl, data: formData).then(
          (response) => response.body<File>(),
        );
  }
}
