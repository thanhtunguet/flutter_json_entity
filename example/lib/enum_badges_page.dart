import 'package:flutter/material.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';
import 'package:supa_architecture/widgets/widgets.dart';

class EnumBadgesPage extends StatelessWidget {
  const EnumBadgesPage({super.key});

  static const List<String> _tokenKeys = <String>[
    'default',
    'warning',
    'information',
    'success',
    'error',
    'blue',
    'cyan',
    'geekblue',
    'gold',
    'green',
    'lime',
    'magenta',
    'orange',
    'purple',
    'red',
    'volcano',
  ];

  @override
  Widget build(BuildContext context) {
    final extended = Theme.of(context).extension<SupaExtendedColorScheme>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enum Badges Demo'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tokenKeys.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final key = _tokenKeys[index];
          final enumModel = EnumModel()
            ..name.rawValue = key
            ..color.rawValue = key
            ..backgroundColor.rawValue = key; // legacy path still supported

          final token = extended?.getTokenGroup(key);

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: token?.background ?? Colors.transparent,
              border: Border.all(color: token?.border ?? Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key, style: Theme.of(context).textTheme.titleMedium),
                EnumStatusBadge(status: enumModel),
              ],
            ),
          );
        },
      ),
    );
  }
}
