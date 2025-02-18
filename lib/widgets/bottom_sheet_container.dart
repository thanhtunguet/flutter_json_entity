import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;

  final double factor;

  const BottomSheetContainer({
    super.key,
    required this.child,
    this.factor = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: factor,
      child: child,
    );
  }
}
