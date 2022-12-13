import 'package:domaine_nc_mobile/widget/search_bar.dart';
import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:flutter/material.dart';

class InfoSearchPage extends StatefulWidget {
  const InfoSearchPage({super.key});

  final edgeInsets = const EdgeInsets.symmetric(horizontal: 20);
  final idTagHero = "searchbar";

  @override
  State<InfoSearchPage> createState() => _InfoSearchPageState();
}

class _InfoSearchPageState extends State<InfoSearchPage> {
  void navigateToSearchDomain() {
    Navigator.pushNamed(context, SearchRoute.searchDomaineRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: widget.edgeInsets,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Chercher un domaine pour avoir plus d'information",
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: widget.idTagHero,
                child: Material(
                  color: Colors.transparent,
                  child: SearchBar(
                    isAutoFocus: false,
                    readOnly: true,
                    callbackOnTap: navigateToSearchDomain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
