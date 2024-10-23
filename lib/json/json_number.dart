part of "json.dart";

/// A class representing a JSON number field.
///
/// This class extends [JsonField] to handle numeric values, providing methods
/// for setting and getting values, and converting to JSON.
class JsonNumber extends JsonField<num> {
  /// Constructs an instance of [JsonNumber].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  JsonNumber(super.fieldName);

  /// Gets the value of the JSON number field.
  ///
  /// **Returns:**
  /// - The numeric value, or 0 if the value is null.
  @override
  num get value => rawValue ?? 0;

  /// Sets the value of the JSON number field.
  ///
  /// **Parameters:**
  /// - `value`: The new value of the field.
  @override
  set value(dynamic value) {
    if (value is num?) {
      rawValue = value;
      return;
    }
    if (value is String) {
      rawValue = num.tryParse(value);
      return;
    }
  }

  /// Converts the numeric value to JSON.
  ///
  /// **Returns:**
  /// - The numeric value in JSON format.
  @override
  num? toJSON() {
    return rawValue;
  }
}
