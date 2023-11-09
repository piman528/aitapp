import 'package:flutter/material.dart';

ThemeData buildThemeLight() {
  return ThemeData.light().copyWith(
    splashColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.blue),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
  );
}

ThemeData buildThemeDark() {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}
