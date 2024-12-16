import 'package:flutter/material.dart';
import 'package:supa_architecture/extensions/extensions.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/widgets/text_status_badge.dart';

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
      color: HexColor.fromHex(status.color.rawValue ?? '#A7F0BA'),
    );
  }
}
