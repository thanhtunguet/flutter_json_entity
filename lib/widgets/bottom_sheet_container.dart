import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;

  final double factor = 0.8;

  const BottomSheetContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: factor,
      child: child,
    );
  }
}
