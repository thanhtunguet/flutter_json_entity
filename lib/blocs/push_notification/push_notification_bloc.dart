import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

part 'push_notification_event.dart';
part 'push_notification_state.dart';

/// A BLoC (Business Logic Component) class for managing push notifications.
///
/// This class handles all actions and behavior for push notifications, including
/// initializing the state, requesting permission, and handling notifications.
class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> {
  /// The BLoC handles all actions and behavior for push notifications. It
  /// initializes the state and handles all events related to push notifications.
  ///
  PushNotificationBloc() : super(PushNotificationInitial()) {
    registerNotificationChannel();
  }

  /// ## Events
  ///
  /// The BLoC listens to the following events:
  ///
  /// - [PushNotificationInitializeEvent]: Initializes the push notification state.
  /// - [PushNotificationPermissionRequestEvent]: Requests permission for push notifications.
  Future<bool> isAndroid13OrHigher() async {
    // Only perform the check if the platform is Android
    if (Platform.isAndroid) {
      // Create an instance of DeviceInfoPlugin
      final deviceInfo = DeviceInfoPlugin();

      // Get Android device info
      final androidInfo = await deviceInfo.androidInfo;

      // Check if the Android version is 13 (API level 33) or higher
      return androidInfo.version.sdkInt >= 33;
    }

    // If it's not Android, return false
    return false;
  }

  /// ## Platform Checks
  ///
  /// The BLoC provides the following methods to check the platform:
  ///
  /// - [isAndroid13OrHigher]: Checks if the platform is Android 13 (API level 33) or higher.
  Future<bool> doesDeviceRequireNotificationPermission() async {
    // Create an instance of DeviceInfoPlugin
    final deviceInfo = DeviceInfoPlugin();

    // Check for iOS devices
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;

      // iOS 10 or higher requires notification permission
      final iosVersion = int.tryParse(iosInfo.systemVersion.split('.')[0]) ?? 0;
      return iosVersion >= 10;
    }

    // Check for Android devices
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      // Android 13 (API level 33) or higher requires notification permission
      return androidInfo.version.sdkInt >= 33;
    }

    // For other platforms or if OS version is below required versions, no permission is needed
    return false;
  }

  /// Checks if the app has notification permission.
  ///
  /// On iOS, the method checks if the notification permission has been granted using
  /// [FlutterLocalNotificationsPlugin]. Starting from iOS 10, explicit permission is required.
  ///
  /// On Android, the method checks if the notification permission is granted starting from
  /// Android 13 (API level 33). On Android versions below 13, notification permission is
  /// granted by default.
  ///
  /// Returns a [Future<bool>] that completes with `true` if notification permission
  /// is granted, or `false` otherwise.
  Future<bool> hasNotificationPermission() async {
    // For iOS
    if (Platform.isIOS) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      return result ?? false;
    }

    // For Android
    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        final status = await Permission.notification.status;
        return status.isGranted;
      } else {
        // Android versions below 13 do not require explicit notification permission
        return true;
      }
    }

    // Default to false for other platforms
    return false;
  }

  /// Private helper function to check if the Android version is 13 or higher (API level 33).
  ///
  /// This is required because Android 13 introduced explicit notification permission.
  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt >= 33;
    }
    return false;
  }

  /// Registers a notification channel using the app's Bundle ID as the notification ID,
  /// and the app's display name as the channel name.
  ///
  /// This method creates a high-priority notification channel for Android 8.0+ (API 26 or higher).
  /// It does not affect iOS devices, as iOS does not use notification channels.
  Future<void> registerNotificationChannel() async {
    if (Platform.isAndroid) {
      // Get app information (Bundle ID and Display Name)
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String appId = packageInfo.packageName; // Bundle ID
      final String appName = packageInfo.appName; // App Display Name

      // Initialize the Flutter Local Notifications Plugin
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Define the notification channel
      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        appId, // Use Bundle ID as the channel ID
        appName, // Use Display Name as the channel name
        description:
            'Notifications for $appName.', // Description for the channel
        importance: Importance.high, // Importance level
      );

      // Register the notification channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      debugPrint(
        'Notification channel created with ID: $appId and Name: $appName',
      );
    }
  }

  /// Handles the [BackgroundMessageHandler] callback when a notification is received while the app is running in the background.
  void registerBackgroundNotificationHandler(
    BackgroundMessageHandler handler,
  ) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
