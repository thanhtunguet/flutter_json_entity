part of 'json.dart';

abstract class JsonField<T> {
  final String fieldName;

  String? error;

  String? warning;

  String? information;

  bool get hasError => error != null;

  bool get hasWarning => warning != null;

  bool get hasInformation => information != null;

  T? rawValue;

  String get nullString => kDebugMode
      ? '<Null check operator used on a null value, from JsonField.name = $fieldName>'
      : '';

  T get value;

  set value(dynamic value) {
    rawValue = value;
  }

  JsonField(this.fieldName);

  dynamic toJSON() {
    return rawValue;
  }
}
