import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Format the input as a currency value with Rupiah.
    final formattedText = NumberFormat.currency(
      symbol: 'Rp ',
      locale: 'id_ID',
      decimalDigits: 0,
    ).format(double.tryParse(text));

    if (formattedText.length > 17) {
      return oldValue;
    } else {
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }
}

String rupiahFormat(num number) {
  if (number <= 0) {
    return 'Rp 0';
  }
  return NumberFormat.currency(symbol: 'Rp ', locale: 'id_ID', decimalDigits: 0)
      .format(number)
      .replaceAll(',', '.');
}
