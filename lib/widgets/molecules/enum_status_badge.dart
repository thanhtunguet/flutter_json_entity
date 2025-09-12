import 'package:flutter/material.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/widgets/atoms/text_status_badge.dart';

class EnumStatusBadge extends StatelessWidget {
  final EnumModel status;

  @Deprecated(
      'Use backgroundColorKey via EnumModel.backgroundColor or theme tokens; this prop will be removed in a future release.')
  final Color? backgroundColor;

  const EnumStatusBadge({
    super.key,
    required this.status,
    @Deprecated(
        'Use backgroundColorKey via EnumModel.backgroundColor or theme tokens; this prop will be removed in a future release.')
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isHex(String? v) => v != null && v.trim().startsWith('#');

    final String? colorRaw = status.color.rawValue;
    final String? computedBorderKey =
        (colorRaw != null && colorRaw.trim().isNotEmpty && !isHex(colorRaw))
            ? colorRaw
            : null;

    return TextStatusBadge(
      status: status.name.rawValue ?? 'Đang tải',
      textColorKey: status.color.rawValue ?? 'default',
      backgroundColorKey: status.backgroundColor.rawValue ?? 'default',
      borderColorKey: computedBorderKey,
    );
  }
}
