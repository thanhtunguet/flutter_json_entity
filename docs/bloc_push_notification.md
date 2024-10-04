### PushNotificationBloc Documentation

The `PushNotificationBloc` is designed to handle push notifications in Flutter applications using Firebase Messaging and Flutter Local Notifications. The bloc emits notification events and states to ensure that the app can react appropriately when a notification is received in the foreground, or when a background notification opens the app. This bloc allows developers to handle notification permissions, register device tokens, and handle both background and foreground notifications.

#### Key Features
- **Listen to Notifications**: The bloc emits states whenever a notification is received, allowing the app to respond to foreground notifications or background notifications when the user opens the app.
- **Foreground Notifications**: When the app is open and running, notifications will still be emitted and can optionally show a local notification.
- **Background Notifications**: Notifications received in the background can be captured when the user taps the notification to open the app.
- **Notification Permissions**: Handles notification permission requests and checks for both iOS and Android platforms.

### How to Use

#### 1. Initialize the Bloc
You can initialize the `PushNotificationBloc` by setting up Firebase Messaging and local notifications. You also need to check and request notification permissions during initialization.

```dart
final pushNotificationBloc = PushNotificationBloc(showLocalNotification: true);

pushNotificationBloc.initializeNotifications(
  appId: 'your_app_id',
  channelName: 'Default Notification Channel',
);
```

#### 2. Listen for Notifications
Use the `BlocListener` or `BlocConsumer` to listen for changes in notification states. The bloc will emit a `PushNotificationReceived` state whenever a notification is received, and a `PushNotificationOpened` state when the user opens the app via a notification.

##### Example:
```dart
BlocConsumer<PushNotificationBloc, PushNotificationState>(
  listener: (context, state) {
    if (state is PushNotificationReceived) {
      // Handle the notification in foreground (e.g., show a dialog or navigate)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(state.title),
          content: Text(state.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } else if (state is PushNotificationOpened) {
      // Handle background notification that opened the app (e.g., navigate to a specific screen)
      Navigator.pushNamed(context, state.linkMobile ?? '/home');
    }
  },
  builder: (context, state) {
    if (state is PushNotificationInitial) {
      return Text("Waiting for notifications...");
    }
    return Container();
  },
);
```

#### 3. Handling Foreground Notifications
If the app is in the foreground, the bloc will emit a `PushNotificationReceived` state. You can decide how to handle this, either by showing an in-app notification or dialog, or by logging the notification for later.

```dart
pushNotificationBloc.setForegroundMessageHandler();
```

#### 4. Handling Background Notifications
When a notification is received in the background and the user taps on it to open the app, the bloc emits a `PushNotificationOpened` state. This allows you to perform navigation or any other action needed when the user interacts with the notification.

```dart
pushNotificationBloc.setNotificationOpenAppHandler();
```

#### 5. Request Notification Permission
Ensure the app has permission to display notifications. If permission is required, the bloc will request it on both iOS and Android (Android 13+).

```dart
Future<void> requestPermissions() async {
  final hasPermission = await pushNotificationBloc.requiresNotificationPermission();
  if (!hasPermission) {
    await pushNotificationBloc.requestNotificationPermission();
  }
}
```

### Example of Full Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_project/blocs/push_notification_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PushNotificationBloc(showLocalNotification: true)
            ..initializeNotifications(appId: 'com.example.app', channelName: 'App Notifications')
            ..setForegroundMessageHandler()
            ..setNotificationOpenAppHandler(),
        ),
      ],
      child: MaterialApp(
        home: NotificationListenerPage(),
      ),
    );
  }
}

class NotificationListenerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Demo'),
      ),
      body: BlocConsumer<PushNotificationBloc, PushNotificationState>(
        listener: (context, state) {
          if (state is PushNotificationReceived) {
            // Handle foreground notification
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(state.title),
                content: Text(state.body),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          } else if (state is PushNotificationOpened) {
            // Handle background notification that opened the app
            Navigator.pushNamed(context, state.linkMobile ?? '/home');
          }
        },
        builder: (context, state) {
          if (state is PushNotificationInitial) {
            return Center(child: Text("Waiting for notifications..."));
          }
          return Container();
        },
      ),
    );
  }
}
```

### Key Methods to Use:
- **`initializeNotifications`**: Initializes Firebase Messaging and local notifications.
- **`requestNotificationPermission`**: Requests notification permission if necessary.
- **`setForegroundMessageHandler`**: Listens for foreground notifications.
- **`setNotificationOpenAppHandler`**: Handles notification interactions when opening the app.
- **`registerDeviceToken`**: Registers the device's Firebase messaging token.

This setup will allow your app to handle notifications efficiently, providing users with both foreground and background notification experiences.