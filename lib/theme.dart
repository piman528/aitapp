import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 35, 132, 223),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 35, 132, 223),
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
