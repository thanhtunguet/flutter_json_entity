part of 'json.dart';

class JsonDate extends JsonField<DateTime> {
  JsonDate(super.fieldName);

  @override
  DateTime get value {
    return rawValue ?? DateTime.now();
  }

  @override
  set value(dynamic value) {
    if (value is String) {
      rawValue = DateTime.tryParse(value);
      return;
    }
    rawValue = value;
  }

  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    if (rawValue == null) {
      return '';
    }
    return value.format(dateFormat: dateFormat);
  }

  @override
  String? toJSON() {
    return rawValue?.toIso8601String();
  }
}
