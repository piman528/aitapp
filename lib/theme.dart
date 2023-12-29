import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 35, 132, 223),
  background: const Color.fromARGB(255, 240, 247, 255),
  secondary: const Color.fromARGB(255, 52, 76, 102),
  primaryContainer: const Color.fromARGB(255, 232, 237, 240),
  secondaryContainer: const Color.fromARGB(255, 188, 218, 247),
  tertiaryContainer: const Color.fromARGB(255, 63, 157, 240),
  onTertiaryContainer: const Color.fromARGB(255, 217, 232, 247),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 35, 132, 223),
  secondary: const Color.fromARGB(255, 148, 181, 218),
  background: const Color.fromARGB(255, 20, 26, 32),
  primaryContainer: const Color.fromARGB(255, 32, 43, 54),
  secondaryContainer: const Color.fromARGB(255, 46, 82, 114),
  tertiaryContainer: const Color.fromARGB(255, 75, 111, 143),
  onTertiaryContainer: const Color.fromARGB(255, 217, 232, 247),
);

ThemeData buildThemeLight() {
  return ThemeData.light().copyWith(
    colorScheme: kColorScheme,
    scaffoldBackgroundColor: kColorScheme.background,
    dividerColor: const Color.fromARGB(255, 201, 201, 201),
    appBarTheme: AppBarTheme(
      backgroundColor: kColorScheme.background,
    ),
  );
}

ThemeData buildThemeDark() {
  return ThemeData.dark().copyWith(
    colorScheme: kDarkColorScheme,
    scaffoldBackgroundColor: kDarkColorScheme.background,
    dividerColor: const Color.fromARGB(255, 59, 59, 59),
    appBarTheme: AppBarTheme(
      backgroundColor: kDarkColorScheme.background,
    ),
  );
}
