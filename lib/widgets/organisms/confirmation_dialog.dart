import 'package:flutter/material.dart';
import 'package:supa_architecture/widgets/atoms/carbon_button.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

class ConfirmationDialog extends StatelessWidget {
  static String Function() defaultOkText = () => 'Tiếp tục';

  static String Function() defaultCancelText = () => 'Huỷ';

  final String title;
  final String? content; // Optional descriptive content shown in the dialog.
  final Widget?
      child; // Custom widget content that can be embedded in the dialog.

  final String? okText; // Text for the confirmation button.
  final String? cancelText; // Text for the cancel button.

  final IconData? icon; // Optional icon displayed at the top of the dialog.

  final VoidCallback
      onConfirm; // Callback for when the confirm button is pressed.
  final VoidCallback?
      onCancel; // Optional callback for when the cancel button is pressed.

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.content,
    this.child,
    required this.onConfirm,
    this.onCancel,
    this.okText,
    this.cancelText,
    this.icon,
  });

  // Closes the dialog by popping the navigation stack.
  void _closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // No rounded corners.
      ),
      icon: Icon(
        icon ?? Icons.check_circle_outline, // Default icon if none is provided.
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      contentPadding: EdgeInsets.zero, // Removes default padding.
      content: Container(
        padding: const EdgeInsets.all(
            16.0), // Adds consistent spacing around content.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content != null)
              Text(
                content!,
                style: theme.textTheme.bodyMedium,
              ),
            if (child != null) child!, // Embeds custom content if provided.
          ],
        ),
      ),
      actionsPadding: EdgeInsets.zero, // Removes default padding for actions.
      actions: <Widget>[
        Row(
          children: [
            // Cancel button
            CarbonButton(
              onPressed: () {
                if (onCancel != null) {
                  onCancel!(); // Triggers the cancel callback if it exists.
                }
                _closeDialog(context); // Closes the dialog.
              },
              label: cancelText ?? defaultCancelText(),
              color: theme.colorScheme.secondary,
              icon: CarbonIcons.close,
              isExpanded: true, // Expands button to fit available space.
            ),
            // Confirm button
            CarbonButton(
              onPressed: () {
                onConfirm(); // Triggers the confirmation callback.
                _closeDialog(context); // Closes the dialog.
              },
              label: okText ?? defaultOkText(),
              color: theme.colorScheme.primary,
              icon: CarbonIcons.checkmark,
              isExpanded: true, // Expands button to fit available space.
            ),
          ],
        ),
      ],
    );
  }
}
