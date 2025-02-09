import 'package:flutter/material.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CarbonIcons.arrow_left),
      onPressed: () {
        if (onPressed != null) {
          onPressed!.call();
        }
        return Navigator.of(context).pop();
      },
    );
  }
}
