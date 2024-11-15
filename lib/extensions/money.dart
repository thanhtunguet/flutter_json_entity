import 'package:intl/intl.dart';

extension NumberFormatter on num {
  String asMoney({
    bool hasDecimals = true,
    String currency = 'VND',
    bool thousandGroup = false,
  }) {
    if (thousandGroup) {
      return '${formatCurrency()} $currency';
    }
    var formatter = NumberFormat(hasDecimals ? '###,###.000' : '###,###');
    var formattedNum = this == 0 ? '0' : formatter.format(this);
    if (formattedNum.endsWith('.000')) {
      formattedNum = formattedNum.substring(0, formattedNum.length - 4);
    }
    if (formattedNum.startsWith('.')) {
      formattedNum = '0$formattedNum';
    }
    return '$formattedNum $currency';
  }

  String formatCurrency() {
    if (this >= 1e9) {
      // Billion
      return '${(this / 1e9).toStringAsFixed(1)}B';
    } else if (this >= 1e6) {
      // Million
      return '${(this / 1e6).toStringAsFixed(1)}M';
    } else {
      var formatter = NumberFormat('###,###.000');
      var formattedNum = this == 0 ? '0' : formatter.format(this);
      if (formattedNum.endsWith('.000')) {
        formattedNum = formattedNum.substring(0, formattedNum.length - 4);
      }
      return formattedNum;
    }
  }
}

extension MoneyFormatter on double {
  String asMoney({
    bool hasDecimals = true,
    String currency = 'VND',
    bool thousandGroup = false,
  }) {
    if (thousandGroup) {
      return '${formatCurrency()} $currency';
    }
    var formatter = NumberFormat(hasDecimals ? '###,###.000' : '###,###');
    var formattedNum = this == 0 ? '0' : formatter.format(this);
    if (formattedNum.endsWith('.000')) {
      formattedNum = formattedNum.substring(0, formattedNum.length - 4);
    }
    if (formattedNum.startsWith('.')) {
      formattedNum = '0$formattedNum';
    }
    return '$formattedNum $currency';
  }
}
