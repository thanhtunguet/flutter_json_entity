part of 'json.dart';

class JsonObject<T extends JsonModel> extends JsonField<T> {
  final InstanceConstructor<T> _type;

  JsonObject(super.fieldName, InstanceConstructor<T> type) : _type = type;

  @override
  set value(dynamic value) {
    if (value is T) {
      _value = value;
      return;
    }
    if (value is Map<String, dynamic>) {
      final model = _type();
      model.fromJSON(value);
      _value = model;
    }
  }

  @override
  toJSON() {
    return _value?.toJSON();
  }
}
