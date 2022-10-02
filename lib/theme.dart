import 'package:flutter/material.dart';

class ThemeDataApp {
  static ThemeData getThemeData() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.yellow,
      ),
      scaffoldBackgroundColor: Colors.grey,
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.yellow,
        textColor: Colors.yellow,
      ),
      
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.yellow),
        ),
        filled: true,
        fillColor: Colors.grey,
      ),
    );
  }
}
