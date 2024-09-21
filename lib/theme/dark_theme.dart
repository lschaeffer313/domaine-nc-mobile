import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkThemeDataApp {
  static const mainColor = Colors.yellow;
  static const secondaryColor = Colors.white;
  static const errorColor = Colors.red;
  static const backgroundColor = Colors.black54;
  static ThemeData getThemeData() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: mainColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return ThemeData(
        brightness: Brightness.dark,
        primarySwatch: DarkThemeDataApp.mainColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: DarkThemeDataApp.mainColor,
          foregroundColor: DarkThemeDataApp.backgroundColor,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: DarkThemeDataApp.mainColor,
          textColor: DarkThemeDataApp.mainColor,
        ),
        colorScheme: const ColorScheme(
          onPrimary: DarkThemeDataApp.mainColor,
          onSecondary: DarkThemeDataApp.secondaryColor,
          brightness: Brightness.dark,
          primary: DarkThemeDataApp.mainColor,
          secondary: DarkThemeDataApp.secondaryColor,
          error: DarkThemeDataApp.errorColor,
          onError: DarkThemeDataApp.mainColor,
          onSurface: DarkThemeDataApp.backgroundColor,
          surface: DarkThemeDataApp.backgroundColor,
        ),
        iconTheme: const IconThemeData(color: DarkThemeDataApp.mainColor),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: DarkThemeDataApp.mainColor,
          suffixStyle: TextStyle(
            color: DarkThemeDataApp.mainColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: DarkThemeDataApp.mainColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: DarkThemeDataApp.mainColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: DarkThemeDataApp.secondaryColor),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: DarkThemeDataApp.mainColor,
        ));
  }
}
