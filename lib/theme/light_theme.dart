import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightThemeDataApp {
  static const mainColor = Colors.yellow;
  static const secondaryColor = Colors.black;
  static const errorColor = Colors.red;
  static const darkColor = Colors.black12;
  static const backgroundColor = Colors.black54;
  static ThemeData getThemeData() {
    const SystemUiOverlayStyle(statusBarColor: LightThemeDataApp.mainColor);
    return ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: LightThemeDataApp.mainColor,
      ),
      scaffoldBackgroundColor: Colors.grey,
      listTileTheme: const ListTileThemeData(
        iconColor: LightThemeDataApp.mainColor,
        textColor: LightThemeDataApp.mainColor,
      ),
      colorScheme: const ColorScheme(
        onPrimary: LightThemeDataApp.mainColor,
        onSecondary: LightThemeDataApp.secondaryColor,
        brightness: Brightness.light,
        primary: LightThemeDataApp.mainColor,
        secondary: LightThemeDataApp.secondaryColor,
        error: LightThemeDataApp.errorColor,
        onError: LightThemeDataApp.mainColor,
        background: LightThemeDataApp.darkColor,
        onBackground: LightThemeDataApp.darkColor,
        onSurface: LightThemeDataApp.backgroundColor,
        surface: LightThemeDataApp.backgroundColor,
      ),
      iconTheme: const IconThemeData(color: LightThemeDataApp.mainColor),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: Colors.black,
        suffixStyle: TextStyle(
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: LightThemeDataApp.mainColor),
        ),
        filled: true,
        fillColor: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: LightThemeDataApp.mainColor,
      ),
    );
  }
}
