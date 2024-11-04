part of "providers.dart";

/// An [ImageProvider] that uses [Dio] to fetch images from a network URL,
/// with support for a fallback asset image if the network image fails to load.
///
/// This class is useful when you need custom HTTP configurations or error handling
/// provided by Dio, such as interceptors, custom headers, or logging.
///
/// **Example Usage:**
/// ```dart
/// Image(
///   image: DioImage(
///     imageUrl: Uri.parse("https://example.com/image.png"),
///     fallbackAssetPath: "assets/images/fallback.png",
///   ),
/// )
/// ```
class DioImageProvider extends ImageProvider<DioImageProvider> {
  /// The [Dio] instance used for network requests.
  ///
  /// You can customize this instance by adding interceptors, modifying options,
  /// or setting custom headers to suit your networking needs.
  final Dio dio = Dio();

  /// The network URL of the image to load.
  ///
  /// This should be a valid [Uri] pointing to the image resource.
  final Uri imageUrl;

  /// The asset path of the fallback image to use if the network image fails to load.
  ///
  /// This should be a valid asset path included in your Flutter project"s `pubspec.yaml`.
  final String fallbackAssetPath;

  /// Creates a new [DioImageProvider] with the given [imageUrl] and [fallbackAssetPath].
  ///
  /// Both [imageUrl] and [fallbackAssetPath] are required and must not be null.
  ///
  /// **Example:**
  /// ```dart
  /// DioImage(
  ///   imageUrl: Uri.parse("https://example.com/image.png"),
  ///   fallbackAssetPath: "assets/images/fallback.png",
  /// )
  /// ```
  DioImageProvider({
    required this.imageUrl,
    required this.fallbackAssetPath,
  }) {
    if (!kIsWeb) {
      dio.interceptors.add(cookieStorageService.getCookieManager());
    }
  }

  /// Obtains the key for this image provider, which is used for caching purposes.
  ///
  /// This method synchronously returns this instance as the key.
  @override
  Future<DioImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DioImageProvider>(this);
  }

  /// Loads the image asynchronously using the given [key] and [decode] callback.
  ///
  /// This method attempts to fetch the image from the network using [Dio].
  /// If the network request succeeds, it decodes the image bytes.
  /// If the network request fails (e.g., due to connectivity issues or a 404 error),
  /// it loads and decodes the fallback asset image specified by [fallbackAssetPath].
  ///
  /// The [decode] callback is used to decode the image data into an [ui.Codec],
  /// which is then used to obtain the image frames.
  ///
  /// This method returns a [OneFrameImageStreamCompleter] that completes with the loaded image.
  @override
  ImageStreamCompleter loadImage(
      DioImageProvider key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_loadAsync(key, decode));
  }

  Future<ImageInfo> _loadAsync(
    DioImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      Response response = await dio.get<List<int>>(
        imageUrl.toString(),
        options: Options(responseType: ResponseType.bytes),
      );
      final Uint8List bytes = Uint8List.fromList(response.data!);

      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);

      // Decode the image bytes
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return ImageInfo(image: frameInfo.image);
    } catch (e) {
      // If network image fails, load the fallback asset image
      final ByteData assetData = await rootBundle.load(fallbackAssetPath);
      final Uint8List bytes = assetData.buffer.asUint8List();
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      // Decode the asset image bytes
      final ui.Codec codec = await decode(buffer);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return ImageInfo(image: frameInfo.image);
    }
  }

  /// Compares this image provider to another for equality.
  ///
  /// Two [DioImageProvider] instances are considered equal if they have the same [imageUrl]
  /// and [fallbackAssetPath].
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final DioImageProvider typedOther = other as DioImageProvider;
    return imageUrl == typedOther.imageUrl &&
        fallbackAssetPath == typedOther.fallbackAssetPath;
  }

  /// Returns a hash code based on the [imageUrl] and [fallbackAssetPath].
  @override
  int get hashCode => Object.hash(imageUrl, fallbackAssetPath);

  /// Returns a string representation of this image provider.
  ///
  /// **Example:**
  /// ```
  /// CustomNetworkImageProvider(url: https://example.com/image.png, fallback: assets/images/fallback.png)
  /// ```
  @override
  String toString() =>
      "${objectRuntimeType(this, "DioImageProvider")}(url: $imageUrl, fallback: $fallbackAssetPath)";

  // Private method to load the image asynchronously.
  //
  // This method is not a public member and does not require documentation for public API usage.
}
