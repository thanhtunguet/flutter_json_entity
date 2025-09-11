import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'enum_badges_page.dart';
import 'supa_color_scheme.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const EnumBadgesPage(),
        ),
      ],
    );

    final ThemeData lightTheme = ThemeData.from(
      colorScheme: lightColorScheme,
      useMaterial3: true,
    ).copyWith(
      extensions: const [lightExtendedColorScheme],
    );

    final ThemeData darkTheme = ThemeData.from(
      colorScheme: darkColorScheme,
      useMaterial3: true,
    ).copyWith(
      extensions: const [darkExtendedColorScheme],
    );

    return MaterialApp.router(
      title: 'Supa Architecture Example',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
