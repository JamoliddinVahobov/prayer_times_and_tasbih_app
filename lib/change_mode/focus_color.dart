import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  Color get textFieldLabelColor {
    // Return blue for light mode, white for dark mode
    return Theme.of(this).brightness == Brightness.light
        ? Colors.black.withOpacity(0.5)
        : Colors.white;
  }

  Color get textFieldFocusBorderColor {
    // Return blue for light mode, white for dark mode
    return Theme.of(this).brightness == Brightness.light
        ? Colors.blue.shade700
        : Colors.white;
  }

  Color get textFieldBorderColor {
    // Return a lighter color for inactive state
    return Theme.of(this).brightness == Brightness.light
        ? Colors.black.withOpacity(0.5)
        : Colors.white.withOpacity(0.5);
  }
}
