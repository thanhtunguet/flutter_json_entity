import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/core/cookie_manager/cookie_manager.dart';
import 'package:supa_architecture/core/persistent_storage/persistent_storage.dart';
import 'package:supa_architecture/supa_architecture.dart' hide Image;

class AppImage extends StatelessWidget {
  PersistentStorage get persistentStorage =>
      GetIt.instance.get<PersistentStorage>();

  CookieManager get cookieManager => GetIt.instance.get<CookieManager>();

  final File? image;

  final String? imagePath;

  final double? width;
  final double? height;

  const AppImage({
    super.key,
    this.image,
    this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final url =
        '${persistentStorage.baseApiUrl}${image?.url.value ?? imagePath}';

    return Image(
      width: width,
      height: height,
      fit: BoxFit.cover,
      image: DioImageProvider(
        imageUrl: Uri.parse(url),
        fallbackAssetPath:
            'packages/supa_architecture/assets/images/image_placeholder.png',
      ),
    );
  }
}
