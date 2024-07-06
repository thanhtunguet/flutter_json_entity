import 'dart:io' as io;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'http_response.dart';

abstract class ApiClient {
  static final defaultDio = Dio();

  final Dio dio;

  String get baseUrl;

  ApiClient({
    bool useDefaultDio = false,
  }) : dio = useDefaultDio ? defaultDio : Dio() {
    if (!useDefaultDio) {
      dio.options.baseUrl = baseUrl;
      final cookieManager = SupaApplication.instance.cookieStorageService.getCookieManager();
      dio.interceptors.add(cookieManager);
    }
  }

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
}
