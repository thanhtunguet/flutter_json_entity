import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:supa_architecture/repositories/utils_notification_repository.dart';
import 'package:supa_architecture/supa_architecture.dart';

part 'push_notification_event.dart';
part 'push_notification_payload.dart';
part 'push_notification_state.dart';

/// Push notification BLoC for handling push notifications.
class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> with Disposable {
  /// Foreground message handler
  StreamSubscription? _foregroundNotificationSubscription;

  StreamSubscription? _notificationOpenSubscription;

  /// Show local notification
  final bool showLocalNotification;

  /// Push notification BLoC for handling push notifications.
  PushNotificationBloc({
    this.showLocalNotification = false,
  }) : super(const PushNotificationInitial()) {
    on<DidReceivedNotificationEvent>(_onDidNotificationReceived);
    on<DidUserOpenedNotificationEvent>(_onDidUserOpenedNotification);
    on<DidResetNotificationEvent>(_onDidResetNotification);
  }

  @override
  FutureOr onDispose() {
    if (_foregroundNotificationSubscription != null) {
      _foregroundNotificationSubscription!.cancel();
      _foregroundNotificationSubscription = null;
    }

    if (_notificationOpenSubscription != null) {
      _notificationOpenSubscription!.cancel();
      _notificationOpenSubscription = null;
    }
  }

  /// Dispose push notification BLoC
  dispose() {
    onDispose();
  }

  _onDidNotificationReceived(
    DidReceivedNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(PushNotificationReceived(
      title: event.title,
      body: event.body,
      payload: event.payload,
      linkMobile: event.linkMobile,
    ));
  }

  _onDidUserOpenedNotification(
    DidUserOpenedNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(PushNotificationOpened(
      title: event.title,
      body: event.body,
      payload: event.payload,
      linkMobile: event.linkMobile,
    ));
  }

  _onDidResetNotification(
    DidResetNotificationEvent event,
    Emitter<PushNotificationState> emit,
  ) {
    emit(const PushNotificationInitial());
  }

  /// Firebase messaging instance
  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;

  /// Flutter local notifications instance
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize push notifications (with default channel for Android).
  /// - Uses app id as the channel id.
  Future<void> initializeNotifications({
    required String appId,
    String? channelName,
  }) async {
    // Check if the app requires notification permission (Android 13+ or iOS).
    await requestNotificationPermission();

    // Initialize Firebase Messaging
    await _initializeFirebaseMessaging();

    // Initialize Local Notifications
    await _initializeLocalNotifications(
      channelId: appId,
      channelName: channelName,
    );

    /// Register device token for notifications.
    await registerDeviceToken();

    /// Set foreground message handler
    setForegroundMessageHandler();

    /// Set notification open app handler
    setNotificationOpenAppHandler();
  }

  /// Check if the app requires notification permission (Android 13+ or iOS).
  Future<bool> requiresNotificationPermission() async {
    if (Platform.isIOS ||
        (Platform.isAndroid && await _isAndroid13OrHigher())) {
      NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.notDetermined;
    }
    return false;
  }

  /// Check if the app already has notification permission.
  Future<bool> hasNotificationPermission() async {
    NotificationSettings settings =
        await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Request notification permission on the corresponding platform.
  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Specify background message handler
  void setBackgroundMessageHandler(
    Future<void> Function(RemoteMessage message) handler,
  ) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  /// Specify foreground message handler
  void setForegroundMessageHandler() {
    _foregroundNotificationSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message);
    });
  }

  /// Specify notification open app handler
  void setNotificationOpenAppHandler() {
    _notificationOpenSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      add(DidUserOpenedNotificationEvent(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: PushNotificationPayload.fromJson(message.data),
        linkMobile: message.data['linkMobile'],
      ));
    });
  }

  /// Handle foreground notifications by showing a local notification
  /// and passing it to the specified message handler.
  void _handleForegroundNotification(RemoteMessage message) async {
    if (showLocalNotification) {
      // Show local notification to indicate incoming message.
      await _showLocalNotification(message);
    }

    add(
      DidReceivedNotificationEvent(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: PushNotificationPayload.fromJson(message.data),
        linkMobile: message.data['linkMobile'],
      ),
    );
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FIREBASE_MESSAGING_TOKEN: $token");
  }

  /// Initialize local notifications (only for Android).
  Future<void> _initializeLocalNotifications({
    required String channelId,
    String? channelName,
  }) async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceivedNotificationResponse,
    );

    // Set the default notification channel on Android.
    if (Platform.isAndroid) {
      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName ?? channelId,
        importance: Importance.high,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  void _onDidReceivedNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    debugPrint(
      "Received notification response: ${notificationResponse.id}, ${notificationResponse.payload}",
    );
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    debugPrint(
      "Received notification: id: $id, title: $title, body: $body, payload: $payload",
    );
  }

  /// Show a local notification on the device (use for foreground notifications).
  Future<void> _showLocalNotification(
    RemoteMessage message, {
    String channelId = 'default_channel',
    String? channelName,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName ?? channelId,
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.notification?.hashCode ?? 0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  /// Private method to check if the device is Android 13 or higher.
  Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  /// Register device token for notifications.
  Future<void> registerDeviceToken() async {
    final bool hasPermission = await hasNotificationPermission();
    if (!hasPermission) return;

    String? token = await _firebaseMessaging.getToken();
    final DeviceInfo deviceInfo = SupaApplication.instance.deviceInfo;

    if (token != null) {
      try {
        await UtilsNotificationRepository().createToken(
          DeviceNotificationToken(
            osVersion: deviceInfo.systemVersion,
            deviceModel: deviceInfo.deviceModel,
            token: token,
          ),
        );
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }

  /// Unregister device token for notifications.
  Future<void> unregisterDeviceToken() async {
    final bool hasPermission = await hasNotificationPermission();
    if (!hasPermission) return;
    String? token = await _firebaseMessaging.getToken();
    final DeviceInfo deviceInfo = SupaApplication.instance.deviceInfo;
    if (token != null) {
      try {
        await UtilsNotificationRepository().deleteToken(
          DeviceNotificationToken(
            osVersion: deviceInfo.systemVersion,
            deviceModel: deviceInfo.deviceModel,
            token: token,
          ),
        );
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }
}
