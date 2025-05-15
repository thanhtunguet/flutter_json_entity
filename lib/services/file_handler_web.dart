import 'dart:html' as html;

Future<void> downloadAndOpenFile(String url, String filename) async {
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
}
