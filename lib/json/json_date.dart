part of 'json.dart';

/// A class representing a JSON date field.
///
/// This class extends [JsonField] to handle `DateTime` values, providing methods
/// for setting and getting values, formatting dates, and converting to JSON.
class JsonDate extends JsonField<DateTime> {
  /// Constructs an instance of [JsonDate].
  ///
  /// **Parameters:**
  /// - `fieldName`: The name of the field.
  JsonDate(super.fieldName);

  /// Gets the value of the JSON date field.
  ///
  /// **Returns:**
  /// - The `DateTime` value, or the current date and time if the value is null.
  @override
  DateTime get value {
    return rawValue ?? DateTime.now();
  }

  /// Sets the value of the JSON date field.
  ///
  /// **Parameters:**
  /// - `value`: The new value of the field.
  @override
  set value(dynamic value) {
    if (value is String) {
      rawValue = DateTime.tryParse(value);
      return;
    }
    rawValue = value;
  }

  /// Formats the date value according to the specified date format.
  ///
  /// **Parameters:**
  /// - `dateFormat`: The format to use for formatting the date (default is `DateTimeFormatsVN.dateOnly`).
  ///
  /// **Returns:**
  /// - A formatted date string.
  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    if (rawValue == null) {
      return '';
    }
    return value.format(dateFormat: dateFormat);
  }

  /// Converts the date value to JSON.
  ///
  /// **Returns:**
  /// - The date value in ISO 8601 string format.
  @override
  String? toJSON() {
    return rawValue?.toIso8601String();
  }
}
