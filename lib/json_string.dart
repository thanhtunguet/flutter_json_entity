part of "json_entity.dart";

/// A class representing a JSON string field.
///
/// This class extends [JsonField] to handle string values, providing methods
/// for setting and getting values, and converting to JSON.
class JsonString extends JsonField<String> {
  /// Constructs an instance of [JsonString].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  JsonString(super.fieldName);

  /// Converts the string value to JSON.
  ///
  /// **Returns:**
  /// - The string value in JSON format.
  @override
  String? toJson() {
    return rawValue;
  }

  /// Gets the value of the JSON string field.
  ///
  /// **Returns:**
  /// - The string value, or a null string if the value is null.
  @override
  String get value => rawValue ?? "";
}
