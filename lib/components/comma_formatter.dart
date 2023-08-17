import 'package:flutter/services.dart';

class CommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String _text = newValue.text;
    return newValue.copyWith(
      text: _text.replaceAll(',', '.'),
    );
  }
}