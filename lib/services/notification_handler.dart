import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supa_architecture/models/user_notification.dart';

abstract class NotificationHandler {
  final BuildContext context;

  NotificationHandler(this.context);

  FutureOr<void> handle(UserNotification userNofication);
}
