part of "json.dart";

/// An extension on the DateTime class to provide additional functionality for
/// formatting DateTime objects with timezone offsets.
extension DateTimeOffsetExtensions on DateTime {
  /// Returns the timezone offset as a string in the format `±hh:mm`.
  /// If the DateTime is in UTC, it returns "Z".
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().getTimezoneOffsetString(); // "+07:00" or "Z" if UTC
  /// ```
  String getTimezoneOffsetString() {
    if (isUtc) {
      return "";
    } else {
      Duration offset = timeZoneOffset;
      String sign = offset.isNegative ? "-" : "+";
      int hours = offset.inHours.abs();
      int minutes = offset.inMinutes.remainder(60).abs();
      return "$sign${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}";
    }
  }

  /// Returns the DateTime object as an ISO 8601 string with timezone offset.
  /// If the DateTime is in UTC, it appends "Z" to the string.
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().toIso8601StringWithOffset(); // "2024-08-07T12:34:56.789+07:00" or "2024-08-07T12:34:56.789Z" if UTC
  /// ```
  String toIso8601StringWithOffset() {
    String iso8601String = toIso8601String();
    String offsetString = getTimezoneOffsetString();
    return iso8601String + offsetString;
  }
}

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
      return "";
    }
    return value.format(dateFormat: dateFormat);
  }

  /// Converts the date value to JSON.
  ///
  /// **Returns:**
  /// - The date value in ISO 8601 string format.
  @override
  String? toJSON() {
    return rawValue?.toUtc().toIso8601String();
  }
}
