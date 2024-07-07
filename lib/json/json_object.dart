part of 'json.dart';

class JsonObject<T extends JsonModel> extends JsonField<T> {
  final InstanceConstructor<T> _type;

  JsonObject(super.fieldName, InstanceConstructor<T> type) : _type = type;

  @override
  set value(dynamic value) {
    if (value is T) {
      rawValue = value;
      return;
    }
    if (value is Map<String, dynamic>) {
      final model = _type();
      model.fromJSON(value);
      rawValue = model;
    }
  }

  @override
  toJSON() {
    return rawValue?.toJSON();
  }
}
