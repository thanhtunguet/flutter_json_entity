part of 'json.dart';

class JsonDate extends JsonField<DateTime> {
  JsonDate(super.fieldName);

  @override
  set value(dynamic value) {
    if (value is String) {
      _value = DateTime.tryParse(value);
      return;
    }
    _value = value;
  }

  @override
  toJSON() {
    return _value?.toIso8601String();
  }
}
