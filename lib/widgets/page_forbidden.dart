import 'package:flutter/material.dart';
import 'package:supa_architecture/widgets/forbidden_component.dart';
import 'package:supa_architecture/widgets/go_back_button.dart';

class PageForbidden extends StatelessWidget {
  const PageForbidden({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Truy cập bị chặn'),
        leading: const GoBackButton(),
      ),
      body: const ForbiddenComponent(
        fallbackRoute: '/',
      ),
    );
  }
}
