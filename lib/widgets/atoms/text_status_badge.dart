import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';

/// A badge widget to display status with automatic text color adjustment
/// based on the background color's luminance.
class TextStatusBadge extends StatelessWidget {
  /// Determines whether the text color should be black or white
  /// based on the luminance of the background color.
  static Color getTextColorBasedOnBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  final String status;

  /// Either provide explicit [color] or a [textColorKey] (token key or hex '#xxxxxx').
  final Color? color;

  /// Token key or hex for text color (e.g., 'warning' or '#FFFFFF').
  final String? textColorKey;

  /// Either provide explicit [backgroundColor] or a [backgroundColorKey] (token key or hex '#xxxxxx').
  @Deprecated(
      'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
  final Color backgroundColor;

  /// Token key or hex for background color (e.g., 'warning' or '#FDDC69').
  final String? backgroundColorKey;

  /// Optional explicit border color. Prefer [borderColorKey] for tokens/hex.
  final Color? borderColor;

  /// Token key or hex for border color (e.g., 'warning' or '#FFD591').
  final String? borderColorKey;

  const TextStatusBadge({
    super.key,
    required this.status,
    @Deprecated(
        'Use backgroundColorKey or theme tokens; this prop will be removed in a future release.')
    this.backgroundColor = const Color(0xFFFDDC69), // Default background color
    this.color = const Color(0xFF000000), // Default text color
    this.textColorKey,
    this.backgroundColorKey,
    this.borderColor,
    this.borderColorKey,
  });

  @override
  Widget build(BuildContext context) {
    final themeExtension =
        Theme.of(context).extension<SupaExtendedColorScheme>();

    Color? resolvedBackground;
    Color? resolvedText;
    Color? resolvedBorder;

    bool isHex(String? v) => v != null && v.trim().startsWith('#');

    final String? bgKey =
        (backgroundColorKey == null || backgroundColorKey!.trim().isEmpty)
            ? null
            : backgroundColorKey!.trim().toLowerCase();

    final String? textKey =
        (textColorKey == null || textColorKey!.trim().isEmpty)
            ? null
            : textColorKey!.trim().toLowerCase();

    final String? borderKey =
        (borderColorKey == null || borderColorKey!.trim().isEmpty)
            ? null
            : borderColorKey!.trim().toLowerCase();

    if (bgKey != null) {
      if (isHex(bgKey)) {
        resolvedBackground = HexColor.fromHex(bgKey);
      } else if (themeExtension != null) {
        resolvedBackground = themeExtension.getBackgroundColor(bgKey);
      }
    }

    if (textKey != null) {
      if (isHex(textKey)) {
        resolvedText = HexColor.fromHex(textKey);
      } else if (themeExtension != null) {
        resolvedText = themeExtension.getTextColor(textKey);
      }
    }

    if (borderKey != null) {
      if (isHex(borderKey)) {
        resolvedBorder = HexColor.fromHex(borderKey);
      } else if (themeExtension != null) {
        resolvedBorder = themeExtension.getBorderColor(borderKey);
      }
    }

    // Default to 'default' token group if neither key provided
    if (bgKey == null &&
        textKey == null &&
        borderKey == null &&
        themeExtension != null) {
      resolvedBackground = themeExtension.getBackgroundColor('default');
      resolvedText = themeExtension.getTextColor('default');
      resolvedBorder = themeExtension.getBorderColor('default');
    }

    final Color effectiveBackground = resolvedBackground ?? backgroundColor;
    final Color effectiveText = resolvedText ??
        color ??
        getTextColorBasedOnBackground(effectiveBackground);
    final Color effectiveBorder =
        borderColor ?? resolvedBorder ?? Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      decoration: ShapeDecoration(
        color: effectiveBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: effectiveBorder, width: 1),
        ),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: effectiveText,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
