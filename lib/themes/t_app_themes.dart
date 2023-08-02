import 'package:flutter/material.dart';

class TAppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      primary: Colors.indigo[800]!,
      secondary: Colors.grey[300]!, //Used for search suggestions
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 8,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo[800]!,
      secondary: Colors.grey[800]!, //Used for search suggestions
      primaryContainer: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 25,
      ),
      labelLarge: TextStyle(fontSize: 18),
      displayMedium: TextStyle(fontSize: 14),
      displaySmall: TextStyle(fontSize: 8),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Colors.white),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
    ),
  );
}
