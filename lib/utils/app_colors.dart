import 'package:flutter/material.dart';

class AppColors {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static const Color primaryGreen = Color(0xFF4F858A);
  static const Color darkGreen = Color(0xFF164445);
  static const Color lightBackground = Color(0xFFF4F8F8);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF262626);
}
