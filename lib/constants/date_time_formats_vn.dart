part of "constants.dart";

/// Constants for formatting dates and times in the Vietnamese locale.
///
/// These formats are designed to be used with the [DateFormat] constructor,
/// specifying the locale as "vi_VN".
///
/// **Example Formats:**
///
/// - `dateTime`: "dd/MM/yyyy HH:mm:ss" (e.g., 01/01/2024 14:30:45)
/// - `dateTimeWithoutSeconds`: "dd/MM/yyyy HH:mm" (e.g., 01/01/2024 14:30)
/// - `dateOnly`: "dd/MM/yyyy" (e.g., 01/01/2024)
/// - `timeOnly`: "HH:mm:ss" (e.g., 14:30:45)
/// - `timeOnlyWithoutSeconds`: "HH:mm" (e.g., 14:30)
/// - `dateWithDayAndMonthOnly`: "dd/MM" (e.g., 01/01)
/// - `yearOnly`: "yyyy" (e.g., 2024)
/// - `dateWithDayName`: "EEEE, dd/MM/yyyy" (e.g., Thứ Hai, 01/01/2024)
/// - `dateWithMonthName`: "dd MMMM yyyy" (e.g., 01 Tháng Một 2024)
/// - `shortDateWithMonthName`: "dd MMM" (e.g., 01 Tháng Một)
abstract class DateTimeFormatsVN {
  /// Full date and time format including seconds.
  static const String dateTime = "dd/MM/yyyy HH:mm:ss";

  /// Date and time format excluding seconds.
  static const String dateTimeWithoutSeconds = "dd/MM/yyyy HH:mm";

  /// Format for date only.
  static const String dateOnly = "dd/MM/yyyy";

  /// Format for time only including seconds.
  static const String timeOnly = "HH:mm:ss";

  /// Format for time only excluding seconds.
  static const String timeOnlyWithoutSeconds = "HH:mm";

  /// Format for day and month only.
  static const String dateWithDayAndMonthOnly = "dd/MM";

  /// Format for year only.
  static const String yearOnly = "yyyy";

  /// Format for full date including the day of the week.
  static const String dateWithDayName = "EEEE, dd/MM/yyyy";

  /// Format for full date including the month name.
  static const String dateWithMonthName = "dd MMMM yyyy";

  /// Short format for date including the month name.
  static const String shortDateWithMonthName = "dd MMM";
}
