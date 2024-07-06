part of 'json.dart';

abstract class JsonField<T> {
  final String fieldName;

  T? _value;

  T get value => _value!;

  T? get rawValue => _value;

  set value(dynamic value) {
    _value = value;
  }

  JsonField(this.fieldName);

  dynamic toJSON() {
    return _value;
  }
}
