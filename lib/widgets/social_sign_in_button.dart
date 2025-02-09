import 'package:flutter/material.dart';

/// A customizable sign-in button with an icon and a title.
///
/// This button is styled with an outlined border and a surface background,
/// and it adapts to the app's theme colors.
///
/// **Usage:**
/// ```dart
/// SignInButton(
///   title: 'Sign in with Google',
///   icon: Icons.login,
///   onPressed: () {},
/// )
/// ```
class SocialSignInButton extends StatelessWidget {
  /// Callback function triggered when the button is pressed.
  final VoidCallback onPressed;

  /// The title text displayed on the button.
  final String title;

  /// The icon displayed on the right side of the button.
  final IconData icon;

  /// Optional color for the text and icon.
  final Color? color;

  /// Creates a [SocialSignInButton] with the given [title], [icon], and [onPressed] function.
  /// The optional [color] parameter customizes the button's icon and text color.
  const SocialSignInButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve theme data from the current context for consistent styling.
    final theme = Theme.of(context);

    // Determine the text and icon color, defaulting to the primary color if none is provided.
    final buttonColor = color ?? theme.colorScheme.primary;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Smooth rounded corners
          side: BorderSide(color: theme.colorScheme.outline), // Outlined border
        ),
        elevation: 1, // Slight elevation for depth effect
        padding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 16), // Proper padding
        textStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: buttonColor), // Text styling
      ),
      onPressed: onPressed, // Button action callback
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display button title with applied theme styles.
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(color: buttonColor),
          ),
          // Display button icon with appropriate size and color.
          Icon(icon, size: 18, color: buttonColor),
        ],
      ),
    );
  }
}
