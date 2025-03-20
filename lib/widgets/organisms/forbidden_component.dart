import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForbiddenComponent extends StatelessWidget {
  final String fallbackRoute;

  const ForbiddenComponent({super.key, required this.fallbackRoute});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/page_forbidden.png'),
            const SizedBox(height: 16),
            const Text(
              'Bạn không có quyền truy cập trang này.',
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                } else {
                  return GoRouter.of(context).go(fallbackRoute);
                }
              },
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
