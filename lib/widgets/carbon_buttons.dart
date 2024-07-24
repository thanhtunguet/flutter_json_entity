import 'package:flutter/material.dart';

class CarbonButton extends StatelessWidget {
  final bool isLoading;

  final bool isExpanded;

  final VoidCallback? onPressed;

  final String label;

  final Color? color;

  final IconData? icon;

  final double size;

  const CarbonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.color,
    this.icon,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            if (isLoading)
              SizedBox(
                width: size,
                height: size,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              )
            else
              Icon(
                icon,
                size: size,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
    return isExpanded
        ? Expanded(
            child: child,
          )
        : child;
  }
}
