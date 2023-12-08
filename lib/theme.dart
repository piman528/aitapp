import 'package:flutter/material.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 35, 207, 255),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 35, 207, 255),
);

ThemeData buildThemeLight() {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: kColorScheme,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.blue),
    ),
  );
}

ThemeData buildThemeDark() {
  return ThemeData.dark().copyWith(
    useMaterial3: true,
    colorScheme: kDarkColorScheme,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.blue),
      color: Color.fromRGBO(46, 46, 46, 255),
    ),
  );
}
