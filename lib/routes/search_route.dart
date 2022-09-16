import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/page/domaine_detail_page.dart';
import 'package:domaine_nc_mobile/page/info_search_page.dart';
import 'package:domaine_nc_mobile/page/search_domaine_page.dart';
import 'package:flutter/material.dart';

class SearchRoute {
  static const defaultRoute = "/";
  static const searchDomaineRoute = "/searchDomaine";
  static const domaineInfoRoute = "/domaineInfo";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case defaultRoute:
        return CustomPageRoute(builder: (_) => const InfoSearchPage());
      case searchDomaineRoute:
        return CustomPageRoute(builder: (_) => const SearchDomainPage());
      case domaineInfoRoute:
        if (args is DomaineSearchResult) {
          return CustomPageRoute(
            builder: (_) => DomaineDetailPage(domaineSearchResult: args),
          );
        }
        break;
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
