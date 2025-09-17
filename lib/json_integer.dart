part of "json_entity.dart";

/// A JSON field that handles integer values.
///
/// The `JsonInteger` class extends `JsonField<int>` and provides
/// functionality to parse and serialize integer values from JSON data.
///
/// **Example Usage:**
/// ```dart
/// // Creating a JsonInteger instance with the field name "age"
/// JsonInteger ageField = JsonInteger("age");
///
/// // Setting the value using an integer
/// ageField.value = 25;
///
/// // Setting the value using a string that can be parsed to an integer
/// ageField.value = "30";
///
/// // Getting the integer value (returns 30)
/// int age = ageField.value;
/// ```
class JsonInteger extends JsonField<int> {
  /// Creates a new [JsonInteger] with the given [fieldName].
  ///
  /// The [fieldName] represents the key in the JSON object that this field corresponds to.
  JsonInteger(super.fieldName);

  /// Gets the integer value of this field.
  ///
  /// If the underlying [rawValue] is `null`, this getter returns `0` by default.
  /// This ensures that the field always provides an integer value when accessed.
  @override
  int get value => rawValue ?? 0;

  /// Sets the value of this field.
  ///
  /// The [value] can be an `int`, `String`, or `null`.
  ///
  /// - If [value] is an `int` or `null`, it is directly assigned to [rawValue].
  /// - If [value] is a `String`, it attempts to parse it into an `int` using `int.tryParse`.
  ///   - If parsing succeeds, the parsed integer is assigned to [rawValue].
  ///   - If parsing fails (e.g., the string is non-numeric), [rawValue] is set to `null`.
  ///
  /// **Examples:**
  /// ```dart
  /// JsonInteger ageField = JsonInteger("age");
  ///
  /// // Setting with an integer
  /// ageField.value = 25; // rawValue is 25
  ///
  /// // Setting with a numeric string
  /// ageField.value = "30"; // rawValue is 30
  ///
  /// // Setting with a non-numeric string
  /// ageField.value = "abc"; // rawValue is null
  /// ```
  @override
  set value(dynamic value) {
    if (value is int?) {
      rawValue = value;
      return;
    }
    if (value is String) {
      rawValue = int.tryParse(value);
      return;
    }
  }

  /// Converts the integer field to a JSON-compatible format.
  ///
  /// Returns the underlying [rawValue], which can be an `int` or `null`.
  ///
  /// This method is used during serialization to include the field in the JSON output.
  ///
  /// **Example:**
  /// ```dart
  /// JsonInteger ageField = JsonInteger("age");
  /// ageField.value = 25;
  ///
  /// Map<String, dynamic> json = {"age": ageField.toJson()}; // {"age": 25}
  /// ```
  @override
  int? toJson() {
    return rawValue;
  }
}
