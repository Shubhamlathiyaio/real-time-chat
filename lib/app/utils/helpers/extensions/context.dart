import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  double get screenWidth => MediaQuery.of(this).size.width;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void hideKeyboard() => FocusScope.of(this).unfocus();
}

// extension StringX on String {
//   String get convertMd5 => md5.convert(utf8.encode(this)).toString();
// }

extension ColorX on Color {
  Color changeOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Opacity must be between 0.0 and 1.0');
    return withAlpha((255.0 * opacity).round());
  }
}
