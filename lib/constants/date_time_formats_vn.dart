/// Constants for formatting dates and times in Vietnamese locale.
///
/// These formats are intended to be used in a [DateFormat] constructor, along
/// with the locale 'vi_VN'.
///
/// **Examples**
///
/// - 'dd/MM/yyyy HH:mm:ss' (01/01/2024 14:30:45)
/// - 'dd/MM/yyyy HH:mm' (01/01/2024 14:30)
/// - 'dd/MM/yyyy' (01/01/2024)
/// - 'HH:mm:ss' (14:30:45)
/// - 'dd/MM' (01/01)
/// - 'yyyy' (2024)
/// - 'EEEE, dd/MM/yyyy' (Thứ Hai, 01/01/2024)
abstract class DateTimeFormatsVN {
  static const String dateTime = 'dd/MM/yyyy HH:mm:ss';

  static const String dateTimeWithoutSeconds = 'dd/MM/yyyy HH:mm';

  static const String dateOnly = 'dd/MM/yyyy';

  static const String timeOnly = 'HH:mm:ss';

  static const String timeOnlyWithoutSeconds = 'HH:mm';

  static const String dateWithDayAndMonthOnly = 'dd/MM';

  static const String yearOnly = 'yyyy';

  static const String dateWithDayName = 'EEEE, dd/MM/yyyy';

  static const String dateWithMonthName = 'dd MMMM yyyy';

  static const String shortDateWithMonthName = 'dd MMM';
}
