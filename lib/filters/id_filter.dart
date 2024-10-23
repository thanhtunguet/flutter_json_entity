part of "filters.dart";

/// This class defines filter operations for ID (primary key, foreign key) fields
/// that is in int type
class IdFilter extends AbstractIdFilter<int> {
  /// This class defines filter operations for ID (primary key, foreign key) fields
  /// that is in int type.
  ///
  /// The [IdFilter] class is a subclass of [AbstractIdFilter] and extends
  /// [AbstractIdFilter] to provide int type filter operations.
  ///
  /// The [IdFilter] class has a single constructor [IdFilter] that takes a
  /// [fieldName] parameter and initializes the [fieldName] property.
  ///
  /// The [fieldName] property holds the name of the ID field.
  IdFilter(super.fieldName);
}
