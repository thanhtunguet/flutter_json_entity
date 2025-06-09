import 'package:web/web.dart';

Future<void> downloadAndOpenFile(String url, String filename) async {
  final anchor = document.createElement('a') as HTMLAnchorElement;
  anchor.href = url;
  anchor.download = filename;
  anchor.click();
}
