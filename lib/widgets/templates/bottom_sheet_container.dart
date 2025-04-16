import 'package:flutter/material.dart';

/// This widget is deprecated. It will be removed in a future version.
@Deprecated(
    'This widget is deprecated. Use a different approach for bottom sheets.')
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
