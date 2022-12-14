import 'package:flutter/material.dart';

// MonA Dark Magenta

Map<int, Color> monaMagentaMap = {
  50: const Color(0xFFf1e5f1),
  100: const Color(0xFFddbedd),
  200: const Color(0xFFc794c8),
  300: const Color(0xFFb06bb2),
  400: const Color(0xFFa04ea1),
  500: const Color(0xFF8f3592),
  600: const Color(0xFF83308c),
  700: const Color(0xFF732a83),
  800: const Color(0xFF64257a),
  900: const Color(0xFF491D68),
};

MaterialColor monaMaterialMagenta = MaterialColor(0xFF491D68, monaMagentaMap);

// ############################################################################
// MonA Dark Green

Map<int, Color> monaGreenMap = {
  50: const Color(0xFFdff1ee),
  100: const Color(0xFFb1ddd5),
  200: const Color(0xFF7fc7ba),
  300: const Color(0xFF4db19e),
  400: const Color(0xFF28a08b),
  500: const Color(0xFF078f78),
  600: const Color(0xFF05836c),
  700: const Color(0xFF03735d),
  800: const Color(0xFF00634f),
  900: const Color(0xFF004735),
};

MaterialColor monaMaterialGreen = MaterialColor(0xFF004735, monaGreenMap);

// ############################################################################
// MonA Dark Yellow

Map<int, Color> monaYellowMap = {
  50: const Color(0xFFfdf7df),
  100: const Color(0xFFfaebaf),
  200: const Color(0xFFf7de7a),
  300: const Color(0xFFf4d241),
  400: const Color(0xFFf3c600), // mona org
  500: const Color(0xFFf2bd00),
  600: const Color(0xFFf3af00),
  700: const Color(0xFFf49c00),
  800: const Color(0xFFf58a00),
  900: const Color(0xFFf66a00),
};

MaterialColor monaMaterialYellow = MaterialColor(0xFFf66a00, monaYellowMap);

// ############################################################################
// MonA Dark Warm Red

Map<int, Color> monaRedMap = {
  50: const Color(0xFFffedf2),
  100: const Color(0xFFffd3dc),
  200: const Color(0xFFf8a2ab),
  300: const Color(0xFFf37e8a), // mona org
  400: const Color(0xFFff5e6c),
  500: const Color(0xFFff4b54),
  600: const Color(0xFFfc4454),
  700: const Color(0xFFe93a4c),
  800: const Color(0xFFdc3444),
  900: const Color(0xFFcd2838),
};

MaterialColor monaMaterialRed = MaterialColor(0xFFcd2838, monaRedMap);

// ############################################################################

class MonAColors {
  ///  A Class Containing the Colors Specific to
  ///  the color scheme of project MonA.

  static const darkMagenta = Color(0xFF732A83);
  static const lightMagenta = Color(0xFFC5AFD6);

  static const darkGreen = Color(0xFF00634F);
  static const lightGreen = Color(0xFFA7D6C8);

  static const darkYellow = Color(0xFFF3C500);
  static const lightYellow = Color(0xFFFFE67A);

  static const darkWarmRed = Color(0xFFF37E89);
  static const lightWarmRed = Color(0xFFFBD2E0);

  static const errorColor = Color(0xFFDA2546);
  static const screenBackgroundColor = Color(0xFFF3F4FD);
}
