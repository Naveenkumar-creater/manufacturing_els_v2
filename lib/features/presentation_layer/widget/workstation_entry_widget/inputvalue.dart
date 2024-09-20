import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int? enteredValue = int.tryParse(newValue.text);
    if (enteredValue != null && enteredValue > maxValue) {
      // If entered value exceeds the maxValue, keep the old value
      return oldValue;
    }
    return newValue;
  }
}
