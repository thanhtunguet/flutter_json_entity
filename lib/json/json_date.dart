part of 'json.dart';

class JsonDate extends JsonField<DateTime> {
  JsonDate(super.fieldName);

  @override
  set value(dynamic value) {
    if (value is String) {
      rawValue = DateTime.tryParse(value);
      return;
    }
    rawValue = value;
  }

  @override
  toJSON() {
    return rawValue?.toIso8601String();
  }
}
