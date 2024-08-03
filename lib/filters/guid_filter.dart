part of 'filters.dart';

/// A filter class for GUID (Globally Unique Identifier) fields.
///
/// This class extends [AbstractIdFilter] to provide filtering capabilities
/// for GUID fields.
class GuidFilter extends AbstractIdFilter<String> {
  /// Constructs an instance of [GuidFilter].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field to be filtered.
  GuidFilter(super.fieldName);
}
