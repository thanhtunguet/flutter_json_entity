import 'package:go_router/go_router.dart';

/// Extension on [String] to provide convenient methods for generating URLs.
///
/// This extension provides the [withId] method to easily generate URLs
/// with an ID parameter.
extension SupaRoute on String {
  /// Generates a URL with an ID parameter.
  String withId(num id) {
    return Uri.parse(this).replace(
      queryParameters: {
        "id": "$id",
      },
    ).toString();
  }
}

extension NumericIdRouterState on GoRouterState {
  int get id => int.parse(uri.queryParameters['id']!);
}
