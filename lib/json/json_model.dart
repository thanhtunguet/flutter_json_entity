part of 'json.dart';

typedef InstanceConstructor<T extends JsonModel> = T Function();

abstract class JsonModel with JsonSerializable {
  static final Map<Type, InstanceConstructor> _types = {};

  static void registerType(Type type, InstanceConstructor constructor) {
    _types[type] = constructor;
  }

  static InstanceConstructor construct(Type type) {
    assert(_types.containsKey(type));
    return _types[type]!;
  }

  List<JsonField> get fields;

  @override
  void fromJSON(dynamic json) {
    assert(json is Map<String, dynamic>);
    if (json is Map<String, dynamic>) {
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
}
