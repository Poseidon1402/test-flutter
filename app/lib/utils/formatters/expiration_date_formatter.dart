import 'package:flutter/services.dart';

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 4 digits (MMYY)
    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      // Insert slash after 2 digits (MM)
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();

    // Ensure cursor stays at end
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
