part of 'json.dart';

abstract class JsonField<T> {
  final String fieldName;

  T? rawValue;

  T get value => rawValue!;

  set value(dynamic value) {
    rawValue = value;
  }

  JsonField(this.fieldName);

  dynamic toJSON() {
    return rawValue;
  }
}
