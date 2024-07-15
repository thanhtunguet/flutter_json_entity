part of 'json.dart';

class JsonDate extends JsonField<DateTime> {
  JsonDate(super.fieldName);

  @override
  DateTime get value {
    assert(rawValue != null);
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
    return DateFormat(dateFormat).format(rawValue!);
  }

  @override
  String? toJSON() {
    return rawValue?.toIso8601String();
  }
}
