import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:supa_architecture/supa_architecture_platform_interface.dart';

/// A custom [ImageProvider] that uses [Dio] to fetch images from a network URL,
/// with support for a fallback asset image if the network image fails to load.
///
/// This provider integrates Dio for custom HTTP configurations like interceptors,
/// headers, and advanced error handling.
class DioImageProvider extends ImageProvider<DioImageProvider> {
  /// The [Dio] instance for handling network requests.
  final Dio dio;

  /// The URL of the network image.
  final Uri imageUrl;

  /// The path to the fallback asset image.
  final String fallbackAssetPath;

  /// Creates a [DioImageProvider] with the required [imageUrl] and [fallbackAssetPath].
  ///
  /// Optionally, a custom [Dio] instance can be provided for advanced configurations.
  DioImageProvider({
    required this.imageUrl,
    required this.fallbackAssetPath,
    Dio? dio,
  }) : dio = dio ?? Dio() {
    if (!kIsWeb) {
      dio?.interceptors.add(
        SupaArchitecturePlatform.instance.cookieStorage.interceptor,
      );
    }
  }

  @override
  Future<DioImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    DioImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  /// Asynchronously loads the image from the network or the fallback asset.
  Future<ImageInfo> _loadAsync(
    DioImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Attempt to load the network image.
      final response = await dio.get<List<int>>(
        imageUrl.toString(),
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) {
        throw Exception("Network response contains no image data.");
      }

      final Uint8List bytes = Uint8List.fromList(response.data!);

      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return ImageInfo(image: frameInfo.image);
    } catch (e, stackTrace) {
      debugPrint('Failed to load network image: $imageUrl. Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      // Fallback to the asset image if the network image fails.
      final ByteData assetData = await rootBundle.load(fallbackAssetPath);
      final Uint8List bytes = assetData.buffer.asUint8List();

      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return ImageInfo(image: frameInfo.image);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    final DioImageProvider typedOther = other as DioImageProvider;
    return imageUrl == typedOther.imageUrl &&
        fallbackAssetPath == typedOther.fallbackAssetPath;
  }

  @override
  int get hashCode => Object.hash(imageUrl, fallbackAssetPath);

  @override
  String toString() {
    return '${objectRuntimeType(this, "DioImageProvider")}'
        '(url: $imageUrl, fallback: $fallbackAssetPath)';
  }
}
