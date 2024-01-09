import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension IntExtension on int {
  static final _numberFmt = NumberFormat("###,###", "en_US");

  String commaSeparated() {
    return _numberFmt.format(this);
  }
}
