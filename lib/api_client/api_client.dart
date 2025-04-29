import "dart:async";
import "dart:io" as io;

import "package:dio/dio.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:image_picker/image_picker.dart";
import "package:path/path.dart";
import "package:supa_architecture/api_client/interceptors/device_info_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/general_error_log_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/persistent_url_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/refresh_interceptor.dart";
import "package:supa_architecture/api_client/interceptors/timezone_interceptor.dart";
import "package:supa_architecture/core/cookie_manager/cookie_manager.dart";
import "package:supa_architecture/core/persistent_storage/persistent_storage.dart";
import "package:supa_architecture/core/secure_storage/secure_storage.dart";
import "package:supa_architecture/json/json.dart";
import "package:supa_architecture/models/models.dart";
import "package:supa_architecture/supa_architecture_platform_interface.dart";

part "dio_exception.dart";
part "http_response.dart";

/// Unified API Client class for handling HTTP requests and file uploads.
abstract class ApiClient {
  CookieManager get cookieStorage => GetIt.instance.get<CookieManager>();
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();
  SecureStorage get secureStorage => GetIt.instance.get<SecureStorage>();

  final Dio dio;

  RefreshInterceptor refreshInterceptor = RefreshInterceptor();

  ApiClient({
    bool shouldUsePersistentUrl = false,
    bool shouldUseDeviceInfo = false,
    RefreshInterceptor? refreshInterceptor,
  }) : dio = Dio() {
    if (refreshInterceptor != null) {
      this.refreshInterceptor = refreshInterceptor;
    }

    dio.options.baseUrl = baseUrl;

    if (shouldUseDeviceInfo) {
      dio.interceptors.add(DeviceInfoInterceptor());
    }

    if (!kIsWeb) {
      dio.interceptors
          .add(SupaArchitecturePlatform.instance.cookieStorage.interceptor);
      if (shouldUsePersistentUrl) {
        dio.interceptors.add(PersistentUrlInterceptor());
      }
    }

    dio.interceptors
      ..add(TimezoneInterceptor())
      ..add(GeneralErrorLogInterceptor())
      ..add(this.refreshInterceptor);
  }

  /// The base URL for API requests.
  String get baseUrl;

  /// Downloads content as bytes from a URL.
  Future<Uint8List> downloadBytes(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Downloads content to a file.
  Future<io.File?> downloadFile({
    required String url,
    required String savePath,
    required String filename,
  }) async {
    final filePath = join(savePath, filename);
    try {
      final response = await dio.download(url, filePath);
      return response.statusCode == 200 ? io.File(filePath) : null;
    } catch (e) {
      return null;
    }
  }

  /// Uploads a single file.
  Future<File> uploadFile({
    required String filePath,
    String uploadUrl = "/upload-file",
    String? filename,
  }) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          filename: filename ?? basename(filePath),
        ),
      });
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files.
  Future<List<File>> uploadFiles({
    required List<String> filePaths,
    String uploadUrl = "/multi-upload-file",
  }) async {
    try {
      final formData = FormData();
      for (final path in filePaths) {
        formData.files.add(MapEntry(
          "files",
          await MultipartFile.fromFile(path, filename: basename(path)),
        ));
      }
      final response = await dio.post(uploadUrl, data: formData);
      return response.bodyAsList<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads a file using [XFile].
  Future<File> uploadFileFromImagePicker(
    XFile file, {
    String uploadUrl = "/upload-file",
  }) async {
    try {
      final formData = FormData.fromMap({
        "file": kIsWeb
            ? MultipartFile.fromBytes(
                await file.readAsBytes(),
                filename: file.name,
              )
            : await MultipartFile.fromFile(file.path),
      });
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files using [XFile].
  Future<List<File>> uploadFilesFromImagePicker(
    List<XFile> files, {
    String uploadUrl = "/multi-upload-file",
  }) async {
    if (kIsWeb) {
      return Future.wait(files.map((file) => uploadFileFromImagePicker(file)));
    }
    try {
      final formData = FormData();
      for (final file in files) {
        formData.files.add(MapEntry(
          "files",
          await MultipartFile.fromFile(file.path),
        ));
      }
      final response = await dio.post(uploadUrl, data: formData);
      return response.bodyAsList<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads a file using [PlatformFile].
  Future<File> uploadFileFromFilePicker(
    PlatformFile file, {
    String uploadUrl = "/upload-file",
  }) async {
    try {
      final formData = FormData.fromMap({
        "file": kIsWeb && file.bytes != null
            ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
            : await MultipartFile.fromFile(file.path!, filename: file.name),
      });
      final response = await dio.post(uploadUrl, data: formData);
      return response.body<File>();
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads multiple files using [PlatformFile].
  Future<List<File>> uploadFilesFromFilePicker(
    List<PlatformFile> files, {
    String uploadUrl = "/multi-upload-file",
  }) async {
    if (kIsWeb) {
      return Future.wait(files.map((file) => uploadFileFromFilePicker(file)));
    }
    try {
      final formData = FormData();
      for (final file in files) {
        formData.files.add(MapEntry(
          "files",
          await MultipartFile.fromFile(file.path!, filename: file.name),
        ));
      }
      final response = await dio.post(uploadUrl, data: formData);
      return response.bodyAsList<File>();
    } catch (e) {
      rethrow;
    }
  }
}
