part of 'json.dart';

typedef InstanceConstructor<T extends JsonModel> = T Function();

abstract class JsonModel with JsonSerializable {
  static final Map<Type, InstanceConstructor> _types = {};

  static void registerType(Type type, InstanceConstructor constructor) {
    _types[type] = constructor;
  }

  static T construct<T extends JsonModel>(Type type) {
    assert(_types.containsKey(type));
    final constructor = _types[type]!;
    return constructor() as T;
  }

  List<JsonField> get fields;

  @override
  void fromJSON(dynamic json) {
    assert(json is Map<dynamic, dynamic>);
    if (json is Map<dynamic, dynamic>) {
      for (final field in fields) {
        if (json.containsKey(field.fieldName)) {
          field.value = json[field.fieldName];
        }
      }
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    final json = <String, dynamic>{};
    for (final field in fields) {
      final fieldValue = field.toJSON();
      if (fieldValue != null) {
        json[field.fieldName] = fieldValue;
      }
    }
    return json;
  }

  @override
  String toString() {
    return jsonEncode(toJSON());
  }

  operator [](String name) {
    for (final field in fields) {
      if (field.fieldName == name) {
        return field.value;
      }
    }
    throw Exception('Field $name is not exist');
  }

  operator []=(String name, value) {
    for (final field in fields) {
      if (field.fieldName == name) {
        field.value = value;
        return;
      }
    }
    throw Exception('Field $name is not exist');
  }
}
