import "package:intl/intl.dart";

import "../constants/constants.dart";

/// Extension on [DateTime] to provide convenient date formatting.
extension DateTimeFormatter on DateTime {
  /// Formats the [DateTime] object into a string using the specified format.
  ///
  /// **Parameters:**
  /// - `dateFormat`: The format to use for the date. Defaults to [DateTimeFormatsVN.dateOnly].
  ///
  /// **Returns:**
  /// - A string representation of the [DateTime] object in the specified format.
  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    return DateFormat(dateFormat).format(toLocal());
  }
}
