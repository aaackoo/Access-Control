import 'package:flutter/material.dart';

class ACColors {
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color white = Color.fromARGB(255, 255, 255, 255);

  static const Color background = Color.fromARGB(255, 250, 250, 250);
  static const Color backgroundAccent = Color.fromARGB(255, 255, 240, 195);
  static const Color backgroundDimmed = Color.fromARGB(255, 229, 228, 228);

  static const Color text = Color.fromARGB(255, 30, 30, 30);
  static const Color textDim = Color.fromARGB(255, 110, 110, 110);

  static const Color primary = Color.fromARGB(
    255,
    105,
    50,
    195,
  );
  static const Color primaryShade = Color.fromARGB(255, 80, 40, 150);

  static const Color secondary = Color.fromARGB(255, 255, 185, 0);
  static const Color secondaryShade = Color.fromARGB(255, 204, 148, 0);

  static const Color accent = Color.fromARGB(255, 255, 185, 0);

  static const Color error = Color.fromARGB(255, 200, 40, 40);
  static const Color warning = Color.fromARGB(255, 245, 125, 0);
  static const Color success = Color.fromARGB(255, 45, 180, 45);
  static const Color info = Color.fromARGB(255, 35, 130, 220);
}

class ACGradients {
  static const LinearGradient accentPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      ACColors.backgroundAccent,
      ACColors.primary,
    ],
  );

  static const LinearGradient dimmedPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      ACColors.background,
      ACColors.textDim,
    ],
  );
}
