part of "json_entity.dart";

/// A mixin that provides methods for JSON serialization and deserialization.
mixin JsonSerializable {
  /// Deserializes the JSON data to the model.
  ///
  /// **Parameters:**
  /// - `json`: The JSON data to deserialize.
  void fromJson(dynamic json);

  /// Serializes the model to JSON.
  ///
  /// **Returns:**
  /// - A map representing the model in JSON format.
  dynamic toJson();
}
