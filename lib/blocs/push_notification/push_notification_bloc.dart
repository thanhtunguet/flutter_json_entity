import "dart:async";
import "dart:convert";
import "dart:io";

import "package:bloc/bloc.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:equatable/equatable.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:supa_architecture/core/device_info.dart";
import "package:supa_architecture/core/device_notification_token.dart";
import "package:supa_architecture/repositories/utils_notification_repository.dart";
import "package:supa_architecture/supa_architecture_platform_interface.dart";

part "push_notification_event.dart";
part "push_notification_payload.dart";
part "push_notification_state.dart";

/// Push notification BLoC for handling push notifications.
class PushNotificationBloc
    extends Bloc<PushNotificationEvent, PushNotificationState> with Disposable {
  /// Foreground message handler
  StreamSubscription? _foregroundNotificationSubscription;
  StreamSubscription? _notificationOpenSubscription;

  /// Push notification BLoC for handling push notifications.
  PushNotificationBloc() : super(const PushNotificationInitial()) {
    on<DidReceivedNotificationEvent>(_onDidNotificationReceived);
    on<DidUserOpenedNotificationEvent>(_onDidUserOpenedNotification);
    on<DidResetNotificationEvent>(_onDidResetNotification);
  }

  @override
  FutureOr onDispose() {
    _foregroundNotificationSubscription?.cancel();
    _notificationOpenSubscription?.cancel();
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

  /// Initialize push notifications (with default channel for Android).
  Future<void> initializeNotifications({
    required String appId,
    String? channelName,
  }) async {
    await requestNotificationPermission();

    await _initializeFirebaseMessaging();

    await registerDeviceToken();

    setForegroundMessageHandler();
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
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        payload: PushNotificationPayload.fromJson(message.data),
        linkMobile: message.data["linkMobile"],
      ));
    });
  }

  /// Handle foreground notifications by showing a local notification
  void _handleForegroundNotification(RemoteMessage message) {
    add(
      DidReceivedNotificationEvent(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        payload: PushNotificationPayload.fromJson(message.data),
        linkMobile: message.data["linkMobile"],
      ),
    );
  }

  /// Initialize Firebase messaging
  Future<void> _initializeFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FIREBASE_MESSAGING_TOKEN: $token");
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
    if (token == null) return;

    final DeviceInfo deviceInfo = SupaArchitecturePlatform.instance.deviceInfo;
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

  /// Unregister device token for notifications.
  Future<void> unregisterDeviceToken() async {
    final bool hasPermission = await hasNotificationPermission();
    if (!hasPermission) return;

    String? token = await _firebaseMessaging.getToken();
    if (token == null) return;

    final DeviceInfo deviceInfo = SupaArchitecturePlatform.instance.deviceInfo;
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
