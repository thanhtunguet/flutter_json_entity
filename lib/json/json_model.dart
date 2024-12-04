part of "json.dart";

/// A type definition for a function that constructs an instance of [JsonModel].
typedef InstanceConstructor<T extends JsonModel> = T Function();

/// An abstract class representing a JSON model.
///
/// This class provides methods for handling JSON serialization and deserialization,
/// managing fields, and handling errors, warnings, and informational messages.
abstract class JsonModel with JsonSerializable {
  /// Map of JSON data.
  Map<String, dynamic> _json = {};

  /// List of JSON fields representing the model attributes.
  List<JsonField> get fields;

  /// List of general errors.
  List<String> generalErrors = [];

  /// List of general warnings.
  List<String> generalWarnings = [];

  /// List of general informational messages.
  List<String> generalInformations = [];

  /// Map of field-specific errors.
  Map<String, String?> errors = {};

  /// Map of field-specific warnings.
  Map<String, String?> warnings = {};

  /// Map of field-specific informational messages.
  Map<String, String?> informations = {};

  /// Checks if the model has any errors.
  bool get hasError => errors.isNotEmpty;

  /// Checks if the model has any warnings.
  bool get hasWarning => warnings.isNotEmpty;

  /// Checks if the model has any informational messages.
  bool get hasInformation => informations.isNotEmpty;

  /// Gets the first general error message.
  String? get error => generalErrors.isNotEmpty ? generalErrors[0] : null;

  /// Gets the first general warning message.
  String? get warning => generalWarnings.isNotEmpty ? generalWarnings[0] : null;

  /// Gets the first general informational message.
  String? get information =>
      generalInformations.isNotEmpty ? generalInformations[0] : null;

  /// Deserializes the JSON data to the model.
  ///
  /// **Parameters:**
  /// - `json`: The JSON data to deserialize.
  @override
  void fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      _json = json;

      if (json.containsKey("generalErrors") && json["generalErrors"] is List) {
        generalErrors = (json["generalErrors"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("generalWarnings") &&
          json["generalWarnings"] is List) {
        generalWarnings = (json["generalWarnings"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("generalInformations") &&
          json["generalInformations"] is List) {
        generalInformations = (json["generalInformations"] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey("errors") && json["errors"] is Map) {
        errors = Map.fromEntries(
          (json["errors"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey("warnings") && json["warnings"] is Map) {
        warnings = Map.fromEntries(
          (json["warnings"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey("informations") && json["informations"] is Map) {
        informations = Map.fromEntries(
          (json["informations"] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      for (final field in fields) {
        if (json.containsKey(field.fieldName)) {
          field.value = json[field.fieldName];
        }

        if (errors.containsKey(field.fieldName)) {
          field.error = errors[field.fieldName];
        }

        if (warnings.containsKey(field.fieldName)) {
          field.warning = warnings[field.fieldName];
        }

        if (informations.containsKey(field.fieldName)) {
          field.information = informations[field.fieldName];
        }
      }
    }
  }

  /// Serializes the model to JSON.
  ///
  /// **Returns:**
  /// - A map representing the model in JSON format.
  @override
  Map<String, dynamic> toJson() {
    final json = _json;
    for (final field in fields) {
      if (field.fieldName.toLowerCase().endsWith('id') &&
          field.fieldName != 'statusId') {
        if (field.value == 0) {
          json.remove(field.fieldName);
          continue;
        }
      }
      if (field.rawValue != null) {
        final fieldValue = field.toJson();
        if (fieldValue != null) {
          json[field.fieldName] = fieldValue;
        }
      }
    }
    return json;
  }

  /// Converts the model to a JSON string.
  ///
  /// **Returns:**
  /// - A JSON string representation of the model.
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// Gets the value of a field by name.
  ///
  /// **Parameters:**
  /// - `name`: The name of the field.
  ///
  /// **Returns:**
  /// - The value of the field.
  ///
  /// **Throws:**
  /// - `Exception` if the field does not exist.
  operator [](String name) {
    for (final field in fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception("Field $name does not exist");
  }

  /// Sets the value of a field by name.
  ///
  /// **Parameters:**
  /// - `name`: The name of the field.
  /// - `value`: The new value to set.
  ///
  /// **Throws:**
  /// - `Exception` if the field does not exist.
  operator []=(String name, value) {
    for (final field in fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception("Field $name does not exist");
  }
}
