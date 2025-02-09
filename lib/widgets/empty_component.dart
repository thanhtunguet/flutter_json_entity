import 'package:flutter/material.dart';

class EmptyComponent extends StatelessWidget {
  final String title;

  final String? subtitle;

  const EmptyComponent({
    super.key,
    this.title = 'Chưa có dữ liệu',
    this.subtitle = 'Keep up the good work!',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage(
              'packages/supa_architecture/assets/images/empty_state.png',
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
        ],
      ),
    );
  }
}
