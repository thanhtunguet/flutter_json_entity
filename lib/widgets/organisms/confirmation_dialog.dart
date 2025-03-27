import 'package:flutter/material.dart';
import 'package:supa_carbon_icons/supa_carbon_icons.dart';

class ConfirmationDialog extends StatelessWidget {
  static String Function() defaultOkText = () => 'Tiếp tục';

  static String Function() defaultCancelText = () => 'Huỷ';

  final IconData? icon;

  final String title;

  final String? content;

  final Widget? child;

  final String? okText;

  final Color? okColor;

  final VoidCallback onConfirm;

  final String? cancelText;

  final Color? cancelColor;

  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.content,
    this.child,
    required this.onConfirm,
    this.onCancel,
    this.okText,
    this.okColor,
    this.cancelText,
    this.cancelColor,
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
      icon: Icon(
        icon ?? Icons.check_circle_outline, // Default icon if none is provided.
        size: 24,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      content: Column(
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
      actions: <Widget>[
        TextButton.icon(
          icon: const Icon(CarbonIcons.close),
          onPressed: () {
            if (onCancel != null) {
              onCancel!(); // Triggers the cancel callback if it exists.
            }
            _closeDialog(context); // Closes the dialog.
          },
          label: Text(
            cancelText ?? defaultCancelText(),
            style: TextStyle(
              color: cancelColor,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            onConfirm(); // Triggers the confirmation callback.
            _closeDialog(context); // Closes the dialog.
          },
          label: Text(
            okText ?? defaultOkText(),
            style: TextStyle(
              color: okColor,
            ),
          ),
          icon: const Icon(CarbonIcons.checkmark),
        ),
      ],
    );
  }
}
