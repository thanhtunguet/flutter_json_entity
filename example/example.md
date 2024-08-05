# Example Documentation for `main.dart`

This documentation provides a detailed walkthrough of the `main.dart` example using the `supa_architecture` package. The example demonstrates initializing the application, setting up environment variables, configuring Sentry for error tracking, and integrating ReCAPTCHA and Toastification.

## Table of Contents

- [Example Documentation for `main.dart`](#example-documentation-for-maindart)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Overview](#overview)
  - [Step-by-Step Guide](#step-by-step-guide)
    - [Initialize the Application](#initialize-the-application)
    - [Load Environment Variables](#load-environment-variables)
    - [Setup ReCAPTCHA](#setup-recaptcha)
    - [Initialize Authentication](#initialize-authentication)
    - [Configure Sentry](#configure-sentry)
    - [Setup Bloc Providers and Toastification](#setup-bloc-providers-and-toastification)
    - [Build the Application](#build-the-application)
  - [Conclusion](#conclusion)

## Prerequisites

Before running this example, ensure you have the following prerequisites:

- Flutter SDK installed
- Environment variables file (`.env`) configured with the following keys:
  - `GOOGLE_RECAPTCHA_ANDROID_KEY`
  - `GOOGLE_RECAPTCHA_IOS_KEY`
  - `SENTRY_DSN`

## Overview

This example demonstrates the following:

- Initializing the Flutter application with `SupaApplication`.
- Loading environment variables using `flutter_dotenv`.
- Setting up ReCAPTCHA using the `RecaptchaConfig` class.
- Initializing and configuring Sentry for error tracking.
- Using `MultiBlocProvider` to manage state with BLoC.
- Displaying Toastification notifications.
- Conditionally displaying content based on authentication state.

## Step-by-Step Guide

### Initialize the Application

Start by initializing Flutter bindings and the `SupaApplication`.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();
  
  await SupaApplication.initialize();
```

### Load Environment Variables

Load the environment variables from the `.env` file.

```dart
await dotenv.load();
```

### Setup ReCAPTCHA

Initialize ReCAPTCHA configuration based on the platform (Android or iOS).

```dart
SupaApplication.initCaptcha(
  captchaConfig: RecaptchaConfig(
    siteKey: Platform.isAndroid
        ? dotenv.env['GOOGLE_RECAPTCHA_ANDROID_KEY']!
        : dotenv.env['GOOGLE_RECAPTCHA_IOS_KEY']!,
  ),
);
```

### Initialize Authentication

Initialize the `AuthenticationBloc`.

```dart
GetIt.instance.get<AuthenticationBloc>().handleInitialize();
```

### Configure Sentry

Configure Sentry for error tracking and performance monitoring.

```dart
await SentryFlutter.init(
  (options) {
    options.dsn = dotenv.env['SENTRY_DSN'];
    options.tracesSampleRate = 1.0;
    options.profilesSampleRate = 1.0;
  },
  appRunner: () => runApp(MyApp()),
);
```

### Setup Bloc Providers and Toastification

Wrap the main application with `ToastificationWrapper` and provide the necessary BLoC providers.

```dart
ToastificationWrapper(
  child: MultiBlocProvider(
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
        // Listener logic here
      },
      builder: (_, state) {
        return MyApp(state: state);
      },
    ),
  ),
);
```

### Build the Application

Define the `MyApp` widget and build the application UI.

```dart
class MyApp extends StatelessWidget {
  final AuthenticationState state;
  
  MyApp({required this.state});
  
  @override
  Widget build(BuildContext context) {
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
  }
}
```

## Conclusion

This example demonstrates a complete setup for initializing and running a Flutter application using the `supa_architecture` package. It covers environment variable loading, ReCAPTCHA setup, Sentry configuration, state management with BLoC, and UI building. By following this guide, you can set up a robust and scalable Flutter application with proper error tracking and state management.
