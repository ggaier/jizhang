import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BillAmountTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final billAmount = double.tryParse(newValue.text);
    if (billAmount == null) {
      return newValue;
    }
    return TextEditingValue(text: billAmount.toStringAsPrecision(2), selection: newValue.selection);
  }
}
