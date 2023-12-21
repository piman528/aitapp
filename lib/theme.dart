import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 89, 175),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 89, 175),
);

ThemeData buildThemeLight() {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: kColorScheme,
    scaffoldBackgroundColor: kColorScheme.background,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: kColorScheme.primary),
    ),
  );
}

ThemeData buildThemeDark() {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: kDarkColorScheme,
    scaffoldBackgroundColor: kDarkColorScheme.background,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: kDarkColorScheme.primary),
    ),
  );
}
