import 'package:flutter/material.dart';

/// A stateless widget that represents a button with an optional loading indicator,
/// icon, and expandable feature.
class CarbonButton extends StatelessWidget {
  /// Indicates whether the button is in a loading state.
  final bool isLoading;

  /// Indicates whether the button should expand to fill available space.
  final bool isExpanded;

  /// The callback to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The label text of the button.
  final String label;

  /// The background color of the button.
  final Color? color;

  /// The icon to display on the button.
  final IconData? icon;

  /// The size of the icon and the loading indicator.
  final double size;

  /// Constructs an instance of [CarbonButton].
  ///
  /// **Parameters:**
  /// - `label`: The label text of the button.
  /// - `onPressed`: The callback to be executed when the button is pressed.
  /// - `isLoading`: Indicates whether the button is in a loading state (default is false).
  /// - `isExpanded`: Indicates whether the button should expand to fill available space (default is false).
  /// - `color`: The background color of the button (optional).
  /// - `icon`: The icon to display on the button (optional).
  /// - `size`: The size of the icon and the loading indicator (default is 16).
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
