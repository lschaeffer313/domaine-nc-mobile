import 'package:flutter/material.dart';

class ThemeDataApp {
  static const mainColor = Colors.yellow;
  static const secondaryColor = Colors.black45;
  static ThemeData getThemeData() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeDataApp.mainColor,
      ),
      scaffoldBackgroundColor: Colors.grey,
      listTileTheme: const ListTileThemeData(
        iconColor: ThemeDataApp.mainColor,
        textColor: ThemeDataApp.mainColor,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          color: ThemeDataApp.secondaryColor,
        ),
      ),
      iconTheme: const IconThemeData(color: ThemeDataApp.mainColor),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: ThemeDataApp.mainColor),
        ),
        filled: true,
        fillColor: Colors.grey,
      ),
    );
  }
}
