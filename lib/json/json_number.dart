part of 'json.dart';

class JsonNumber extends JsonField<num> {
  JsonNumber(super.fieldName);

  @override
  num get value => rawValue ?? 0;

  @override
  set value(dynamic value) {
    if (value is num?) {
      rawValue = value;
      return;
    }
    if (value is String) {
      rawValue = num.tryParse(value);
      return;
    }
  }

  @override
  num? toJSON() {
    return rawValue;
  }
}
