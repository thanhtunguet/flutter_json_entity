part of 'json.dart';

class JsonObject<T extends JsonModel> extends JsonField<T> {
  final InstanceConstructor<T> _type;

  JsonObject(super.fieldName, InstanceConstructor<T> type) : _type = type;

  @override
  T get value => rawValue ?? _type();

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
  Map<String, dynamic>? toJSON() {
    return rawValue?.toJSON();
  }

  operator [](String name) {
    if (rawValue == null) {
      return null;
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception('Field $name is not exist');
  }

  operator []=(String name, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception('Field $name is not exist');
    }
    for (final field in rawValue!.fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception('Field $name is not exist');
  }
}
