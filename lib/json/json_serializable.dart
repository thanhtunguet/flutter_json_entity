part of 'json.dart';

/// A mixin that provides methods for JSON serialization and deserialization.
mixin JsonSerializable {
  /// Deserializes the JSON data to the model.
  ///
  /// **Parameters:**
  /// - `json`: The JSON data to deserialize.
  void fromJSON(dynamic json);

  /// Serializes the model to JSON.
  ///
  /// **Returns:**
  /// - A map representing the model in JSON format.
  dynamic toJSON();
}
