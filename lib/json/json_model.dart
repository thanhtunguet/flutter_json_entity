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

  List<String> generalErrors = [];

  List<String> generalWarnings = [];

  List<String> generalInformations = [];

  Map<String, String?> errors = {};

  Map<String, String?> warnings = {};

  Map<String, String?> informations = {};

  bool get hasError => errors.isNotEmpty;

  bool get hasWarning => warnings.isNotEmpty;

  bool get hasInformation => informations.isNotEmpty;

  String? get error => generalErrors[0];

  String? get warning => generalWarnings[0];

  String? get information => generalInformations[0];

  @override
  void fromJSON(dynamic json) {
    assert(json is Map<dynamic, dynamic>);
    if (json is Map<dynamic, dynamic>) {
      if (json.containsKey('generalErrors') && json['generalErrors'] is List) {
        generalErrors = (json['generalErrors'] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey('generalWarnings') &&
          json['generalWarnings'] is List) {
        generalWarnings = (json['generalWarnings'] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey('generalInformations') &&
          json['generalInformations'] is List) {
        generalInformations = (json['generalInformations'] as List<dynamic>)
            .map((dynamic item) => item as String)
            .toList();
      }

      if (json.containsKey('errors') && json['errors'] is Map) {
        errors = Map.fromEntries(
          (json['errors'] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey('warnings') && json['warnings'] is Map) {
        warnings = Map.fromEntries(
          (json['warnings'] as Map)
              .entries
              .map((MapEntry<dynamic, dynamic> entry) {
            final key = entry.key as String;
            final value = entry.value as String?;
            return MapEntry(key, value);
          }),
        );
      }

      if (json.containsKey('informations') && json['informations'] is Map) {
        informations = Map.fromEntries(
          (json['informations'] as Map)
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
