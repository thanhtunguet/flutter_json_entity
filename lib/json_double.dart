part of "json_entity.dart";

/// A JSON field that handles double-precision floating-point values.
///
/// The `JsonDouble` class extends `JsonField<double>` and provides
/// functionality to parse and serialize double values from JSON data.
///
/// **Example Usage:**
/// ```dart
/// // Creating a JsonDouble instance with the field name "price"
/// JsonDouble priceField = JsonDouble("price");
///
/// // Setting the value using a double
/// priceField.value = 19.99;
///
/// // Setting the value using a string that can be parsed to a double
/// priceField.value = "29.99";
///
/// // Getting the double value (returns 29.99)
/// double price = priceField.value;
/// ```
class JsonDouble extends JsonField<double> {
  /// Creates a new [JsonDouble] with the given [fieldName].
  ///
  /// The [fieldName] represents the key in the JSON object that this field corresponds to.
  JsonDouble(super.fieldName);

  /// Gets the double value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `0.0` by default.
  /// This ensures that the field always provides a double value when accessed.
  @override
  double get value => rawValue ?? 0;

  /// Sets the value of this field.
  ///
  /// The [value] can be a `double`, `String`, or `null`.
  ///
  /// - If [value] is a `double` or `null`, it is directly assigned to [rawValue].
  /// - If [value] is a `String`, it attempts to parse it into a `double` using `double.tryParse`.
  ///   - If parsing succeeds, the parsed double is assigned to [rawValue].
  ///   - If parsing fails (e.g., the string is non-numeric), [rawValue] is set to `null`.
  ///
  /// **Examples:**
  /// ```dart
  /// JsonDouble priceField = JsonDouble("price");
  ///
  /// // Setting with a double
  /// priceField.value = 19.99; // rawValue is 19.99
  ///
  /// // Setting with a numeric string
  /// priceField.value = "29.99"; // rawValue is 29.99
  ///
  /// // Setting with a non-numeric string
  /// priceField.value = "abc"; // rawValue is null
  /// ```
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = null;
      return;
    }
    if (value is double) {
      rawValue = value;
      return;
    }
    if (value is int) {
      rawValue = value.toDouble();
      return;
    }
    if (value is String) {
      rawValue = double.tryParse(value);
      return;
    }
    // Attempt to handle other data types via conversion
    try {
      rawValue = double.tryParse(value.toString());
    } catch (_) {
      rawValue = null; // Fallback if conversion fails
    }
  }

  /// Converts the double field to a JSON-compatible format.
  ///
  /// Returns the underlying [rawValue], which can be a `double` or `null`.
  ///
  /// This method is used during serialization to include the field in the JSON output.
  ///
  /// **Example:**
  /// ```dart
  /// JsonDouble priceField = JsonDouble("price");
  /// priceField.value = 19.99;
  ///
  /// Map<String, dynamic> json = {"price": priceField.toJson()}; // {"price": 19.99}
  /// ```
  @override
  double? toJson() {
    return rawValue;
  }
}
