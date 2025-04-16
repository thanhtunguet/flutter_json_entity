import 'package:flutter/material.dart';

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

  final Color? color;

  final Color backgroundColor;

  const TextStatusBadge({
    super.key,
    required this.status,
    this.backgroundColor = const Color(0xFFFDDC69), // Default background color
    this.color = const Color(0xFF000000), // Default text color
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? getTextColorBasedOnBackground(backgroundColor);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
