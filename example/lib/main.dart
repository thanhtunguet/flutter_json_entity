import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supa_architecture/supa_architecture.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await SupaApplication.initialize();

  SupaApplication.initCaptcha(
    captchaConfig: RecaptchaConfig(
      siteKey: Platform.isAndroid
          ? dotenv.env['GOOGLE_RECAPTCHA_ANDROID_KEY']!
          : dotenv.env['GOOGLE_RECAPTCHA_IOS_KEY']!,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (_) => GetIt.instance.get<AuthenticationBloc>(),
          ),
          BlocProvider<TenantBloc>(
            create: (_) => GetIt.instance.get<TenantBloc>(),
          ),
        ],
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (_, state) {
            ///
          },
          builder: (_, state) {
            return MaterialApp(
              theme: ThemeData(),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                appBar: AppBar(
                  title: const Text('Example for supa_architecture'),
                ),
                body: Center(
                  child: Text(
                    state.isAuthenticated
                        ? 'User is authenticated'
                        : 'User is not authenticated',
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
