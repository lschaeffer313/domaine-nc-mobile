import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:domaine_nc_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "fr_FR";
    initializeDateFormatting("fr_FR");
    return MaterialApp(
      title: 'DomaineNcMobile',
      theme: ThemeDataApp.getThemeData(),
      initialRoute: '/',
      onGenerateRoute: SearchRoute.generateRoute,
    );
  }
}
