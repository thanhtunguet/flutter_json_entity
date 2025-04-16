import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/widgets/atoms/text_status_badge.dart';

class EnumStatusBadge extends StatelessWidget {
  final EnumModel status;

  const EnumStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return TextStatusBadge(
      status: status.name.rawValue ?? 'Đang tải',
      color: _getColorFromHex(
        status.color.rawValue,
        defaultValue: Colors.black,
      ),
      backgroundColor: _getColorFromHex(
        status.backgroundColor.rawValue,
        defaultValue: Colors.grey.shade200,
      ),
    );
  }

  static Color _getColorFromHex(
    String? hexColor, {
    required Color defaultValue,
  }) {
    if (hexColor == null || hexColor.isEmpty) {
      return defaultValue;
    }
    try {
      return HexColor.fromHex(hexColor);
    } catch (e) {
      return defaultValue;
    }
  }
}
