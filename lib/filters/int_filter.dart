part of 'filters.dart';

/// A filter class for integer fields.
///
/// This class extends [AbstractNumberFilter] to provide filtering capabilities
/// for integer fields.
class IntFilter extends AbstractNumberFilter<int> {
  /// Constructs an instance of [IntFilter].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field to be filtered.
  IntFilter(super.fieldName);
}
