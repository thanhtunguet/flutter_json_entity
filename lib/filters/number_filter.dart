part of 'filters.dart';

/// A filter class for numeric fields.
///
/// This class extends [AbstractNumberFilter] to provide filtering capabilities
/// for numeric fields.
class NumberFilter extends AbstractNumberFilter<num> {
  /// Constructs an instance of [NumberFilter].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field to be filtered.
  NumberFilter(super.fieldName);
}
