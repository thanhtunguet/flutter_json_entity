import 'package:flutter/material.dart';

class IconPlaceholder extends StatelessWidget {
  final double? size;

  const IconPlaceholder({
    super.key,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
    );
  }
}
