import 'package:intl/intl.dart';

class NumberFormater {
  static String numFormat(int value) {
    final oCcy = NumberFormat.currency(
      decimalDigits: 0,
      locale: 'eu',
      symbol: '',
      customPattern: '#,### \u00a4',
    );
    return oCcy.format(value);
  }
}
