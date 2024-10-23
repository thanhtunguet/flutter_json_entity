import "package:flutter/material.dart";

/// A stateless widget that displays a field label.
///
/// This widget displays a text label with an optional required indicator.
/// The label style can be customized using the [style] parameter.
class FieldLabel extends StatelessWidget {
  /// The text label to display.
  final String label;

  /// Indicates whether the field is required.
  final bool isRequired;

  /// The style to apply to the text label.
  final TextStyle? style;

  /// Constructs an instance of [FieldLabel].
  ///
  /// **Parameters:**
  /// - `label`: The text label to display.
  /// - `style`: The style to apply to the text label (optional).
  /// - `isRequired`: Indicates whether the field is required (default is false).
  const FieldLabel({
    super.key,
    required this.label,
    this.style,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: labelStyle,
          ),
          if (isRequired)
            TextSpan(
              text: " *",
              style: labelStyle?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
