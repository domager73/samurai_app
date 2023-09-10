import 'package:flutter/services.dart';

class CommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;
    return newValue.copyWith(
      text: text.replaceAll(',', '.'),
    );
  }
}