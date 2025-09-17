part of "json_entity.dart";

/// A class representing a JSON boolean field.
///
/// This class extends [JsonField] to handle boolean values, providing methods
/// for getting values and converting to JSON.
class JsonBoolean extends JsonField<bool> {
  /// Constructs an instance of [JsonBoolean].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  JsonBoolean(super.fieldName);

  /// Gets the value of the JSON boolean field.
  ///
  /// **Returns:**
  /// - The boolean value, or `false` if the value is null.
  @override
  bool get value {
    return rawValue ?? false;
  }

  /// Converts the boolean value to JSON.
  ///
  /// **Returns:**
  /// - The boolean value in JSON format.
  @override
  bool? toJson() {
    return rawValue;
  }
}
