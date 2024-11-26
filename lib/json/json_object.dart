part of "json.dart";

/// A class representing a JSON object field.
///
/// This class extends [JsonField] to handle objects of type [T] which extends [JsonModel].
/// It provides methods for setting and getting values, converting to JSON,
/// and accessing nested fields within the object.
class JsonObject<T extends JsonModel> extends JsonField<T> {
  /// Constructs an instance of [JsonObject].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  /// - `type`: The constructor for creating instances of type [T].
  JsonObject(super.fieldName);

  /// Gets the value of the JSON object field.
  ///
  /// **Returns:**
  /// - An instance of [T], or a new instance if the value is null.
  @override
  T get value {
    if (rawValue == null) {
      return GetIt.instance.get<T>();
    }
    return rawValue!;
  }

  /// Sets the value of the JSON object field.
  ///
  /// **Parameters:**
  /// - `value`: The new value of the field.
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = null;
      return;
    }
    if (value is T) {
      rawValue = value;
      return;
    }
    if (value is Map<String, dynamic>) {
      final model = GetIt.instance.get<T>();
      model.fromJson(value);
      rawValue = model;
    }
  }

  /// Converts the object to JSON.
  ///
  /// **Returns:**
  /// - A map representing the object in JSON format.
  @override
  Map<String, dynamic>? toJson() {
    return rawValue?.toJson();
  }

  /// Gets the value of a nested field by name.
  ///
  /// **Parameters:**
  /// - `name`: The name of the nested field.
  ///
  /// **Returns:**
  /// - The value of the nested field.
  ///
  /// **Throws:**
  /// - `Exception` if the field does not exist.
  operator [](String name) {
    if (rawValue == null) {
      return null;
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception("Field $name does not exist");
  }

  /// Sets the value of a nested field by name.
  ///
  /// **Parameters:**
  /// - `name`: The name of the nested field.
  /// - `value`: The new value to set.
  ///
  /// **Throws:**
  /// - `Exception` if the field does not exist.
  operator []=(String name, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception("Field $name does not exist");
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception("Field $name does not exist");
  }
}
