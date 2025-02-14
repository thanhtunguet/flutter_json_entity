import 'package:flutter/widgets.dart';

abstract class EntityDetailNavigator<T> {
  Future<void> navigate(
    BuildContext context,
    int entityId, {
    dynamic extra,
    bool useNavigator = false,
  });

  dynamic handle403(BuildContext context);

  dynamic handle404(BuildContext context);

  Future<T> getEntity();
}
