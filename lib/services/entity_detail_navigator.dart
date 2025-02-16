import 'package:flutter/widgets.dart';

abstract class EntityDetailNavigator<T> {
  Future<void> navigate(
    BuildContext context,
  );

  Future<T> getEntity(int entityId);
}
