import 'package:injectable/injectable.dart';

import 'file_handler_web.dart' if (dart.library.io) 'file_handler_io.dart'
    as platform;

@singleton
class FileHandler {
  Future<void> downloadAndOpen(String url, String filename) async {
    await platform.downloadAndOpenFile(url, filename);
  }
}
