import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        if (Navigator.of(context).canPop()) {
          return Navigator.of(context).pop();
        }
        return GoRouter.of(context).go("/");
      },
    );
  }
}
