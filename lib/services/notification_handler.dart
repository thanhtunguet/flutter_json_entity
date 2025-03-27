import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supa_architecture/models/user_notification.dart';

/// A utility class for handling and processing notifications.
///
/// The `NotificationHandler` provides methods to register handlers for specific types
/// of notifications and to process incoming notifications by routing them to the
/// appropriate handler.
///
/// ## Example
///
/// ```dart
/// // Create a handler for the NotificationHandler
/// final notificationHandler = NotificationHandler();
///
/// // Register handlers for different notification types
/// notificationHandler.registerHandler<TextNotification>((notification) {
///   print('Received text notification: ${notification.text}');
/// });
///
/// notificationHandler.registerHandler<ImageNotification>((notification) {
///   print('Received image notification with URL: ${notification.imageUrl}');
/// });
///
/// // Process incoming notifications
/// final textNotif = TextNotification('Hello, world!');
/// notificationHandler.handle(textNotif); // Prints: Received text notification: Hello, world!
///
/// final imageNotif = ImageNotification('https://example.com/image.jpg');
/// notificationHandler.handle(imageNotif); // Prints: Received image notification with URL: https://example.com/image.jpg
/// ```
///
/// This pattern allows for decoupling notification processing logic and
/// handling different notification types without complex conditional statements.
abstract class NotificationHandler {
  final BuildContext context;

  NotificationHandler(this.context);

  FutureOr<void> handle(UserNotification userNofication);
}
