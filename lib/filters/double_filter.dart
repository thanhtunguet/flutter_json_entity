part of "filters.dart";

/// A filter class for double fields.
///
/// This class extends [AbstractNumberFilter] to provide filtering capabilities
/// for double fields.
class DoubleFilter extends AbstractNumberFilter<double> {
  /// Constructs an instance of [DoubleFilter].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field to be filtered.
  DoubleFilter(super.fieldName);
}
