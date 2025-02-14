import 'package:flutter/widgets.dart';

abstract class EntityDetailNavigator {
  Future<void> navigate(
    BuildContext context,
    String entityId, {
    dynamic extra,
    bool useNavigator = false,
  });

  handle403(BuildContext context);

  handle404(BuildContext context);
}
