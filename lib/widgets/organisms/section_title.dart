import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  final bool showPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.showPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: showPadding
          ? const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            )
          : null,
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
