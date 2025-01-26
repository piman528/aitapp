import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 35, 132, 223),
  surface: const Color.fromARGB(255, 255, 255, 255),
  secondary: const Color.fromARGB(255, 52, 76, 102),
  primaryContainer: const Color.fromARGB(255, 232, 232, 232),
  onPrimaryContainer: Colors.black,
  secondaryContainer: const Color.fromARGB(255, 188, 218, 247),
  tertiaryContainer: const Color.fromARGB(255, 63, 157, 240),
  onTertiaryContainer: const Color.fromARGB(255, 252, 252, 252),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 35, 132, 223),
  secondary: const Color.fromARGB(255, 148, 181, 218),
  surface: const Color.fromARGB(255, 27, 27, 27),
  primaryContainer: const Color.fromARGB(255, 43, 43, 43),
  onPrimaryContainer: const Color.fromARGB(255, 255, 255, 255),
  secondaryContainer: const Color.fromARGB(255, 46, 82, 114),
  tertiaryContainer: const Color.fromARGB(255, 75, 111, 143),
  onTertiaryContainer: const Color.fromARGB(255, 255, 255, 255),
);

ThemeData buildThemeLight() {
  return ThemeData.light().copyWith(
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: kColorScheme,
    scaffoldBackgroundColor: kColorScheme.surface,
    dividerColor: const Color.fromARGB(255, 201, 201, 201),
    appBarTheme: AppBarTheme(
      backgroundColor: kColorScheme.surface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    ),
  );
}

ThemeData buildThemeDark() {
  return ThemeData.dark().copyWith(
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    colorScheme: kDarkColorScheme,
    scaffoldBackgroundColor: kDarkColorScheme.surface,
    dividerColor: const Color.fromARGB(255, 59, 59, 59),
    appBarTheme: AppBarTheme(
      backgroundColor: kDarkColorScheme.surface,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 34, 34, 34),
    ),
  );
}
