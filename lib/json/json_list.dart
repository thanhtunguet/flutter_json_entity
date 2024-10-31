part of "json.dart";

/// A class representing a JSON list field.
///
/// This class extends [JsonField] to handle lists of [JsonModel] objects,
/// providing methods for setting and getting values, converting to JSON,
/// and accessing list elements.
class JsonList<T extends JsonModel> extends JsonField<List<T>> {
  /// Constructs an instance of [JsonList].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  /// - `type`: The constructor for creating instances of type [T].
  JsonList(super.fieldName) {
    rawValue = [];
  }

  /// Gets the value of the JSON list field.
  ///
  /// **Returns:**
  /// - The list of [T] objects.
  @override
  List<T> get value => rawValue ?? [];

  /// Sets the value of the JSON list field.
  ///
  /// **Parameters:**
  /// - `value`: The new value of the field.
  @override
  set value(dynamic value) {
    if (value == null) {
      rawValue = [];
      return;
    }
    if (value is List<T>) {
      rawValue = value;
      return;
    }
    if (value is List) {
      rawValue = value.map((element) {
        final model = GetIt.instance.get<T>();
        model.fromJSON(element);
        return model;
      }).toList();
    }
  }

  /// Converts the list of [T] objects to JSON.
  ///
  /// **Returns:**
  /// - A list of JSON maps representing the [T] objects.
  @override
  List<Map<String, dynamic>>? toJSON() {
    return rawValue?.map((element) => element.toJSON()).toList();
  }

  /// Gets the element at the specified index.
  ///
  /// **Parameters:**
  /// - `index`: The index of the element.
  ///
  /// **Returns:**
  /// - The element at the specified index.
  ///
  /// **Throws:**
  /// - `Exception` if the index is out of range.
  operator [](int index) {
    if (rawValue == null) {
      return null;
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception("Index $index is out of range");
    }
    return rawValue![index];
  }

  /// Sets the element at the specified index.
  ///
  /// **Parameters:**
  /// - `index`: The index of the element.
  /// - `value`: The new value to set at the specified index.
  ///
  /// **Throws:**
  /// - `Exception` if the index is out of range.
  operator []=(int index, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception("Index $index is out of range");
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception("Index $index is out of range");
    }
    rawValue![index] = value;
  }
}
