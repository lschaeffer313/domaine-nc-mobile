import 'package:domaine_nc_mobile/page/info_search_page.dart';
import 'package:domaine_nc_mobile/page/search_domaine_page.dart';
import 'package:flutter/material.dart';

class SearchRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CustomPageRoute(builder: (_) => const InfoSearchPage());
      case '/searchDomain':
        return CustomPageRoute(builder: (_) => const SearchDomainPage());
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(child: Text("ERROR")),
      );
    });
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  CustomPageRoute({builder}) : super(builder: builder);
}
