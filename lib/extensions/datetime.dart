import 'package:intl/intl.dart';
import 'package:supa_architecture/supa_architecture.dart';

extension DateTimeFormatter on DateTime {
  String format({
    String dateFormat = DateTimeFormatsVN.dateOnly,
  }) {
    return DateFormat(dateFormat).format(toLocal());
  }
}
