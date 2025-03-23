import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;

  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
