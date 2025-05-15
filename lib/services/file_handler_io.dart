import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supa_architecture/supa_architecture.dart';

class _FileRepository extends ApiClient {
  @override
  String get baseUrl => persistentStorage.baseApiUrl;
}

final _repository = _FileRepository();

Future<void> downloadAndOpenFile(String url, String filename) async {
  final savedPath = await getTemporaryDirectory();
  final ioFile = await _repository.downloadFile(
    url: url,
    savePath: savedPath.path,
    filename: filename,
  );

  if (ioFile != null) {
    OpenFile.open(ioFile.path);
  }
}
