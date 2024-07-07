import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String label;

  final bool isRequired;

  final TextStyle? style;

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
              text: ' *',
              style: labelStyle?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
