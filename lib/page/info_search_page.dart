import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:flutter/material.dart';

class InfoSearchPage extends StatefulWidget {
  const InfoSearchPage({super.key});

  final edgeInsets = const EdgeInsets.symmetric(horizontal: 20);
  final Color colorPageTheme = Colors.grey;
  final idTagHero = "searchbar";

  @override
  State<InfoSearchPage> createState() => _InfoSearchPageState();
}

class _InfoSearchPageState extends State<InfoSearchPage> {
  void navigateToSearchDomain() {
    Navigator.pushNamed(context, SearchRoute.searchDomaineRoute);
  }

  Widget _searchBar() {
    return Hero(
      tag: widget.idTagHero,
      child: Material(
        color: Colors.grey,
        child: TextField(
          onTap: () => navigateToSearchDomain(),
          readOnly: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colorPageTheme,
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
              _searchBar()
            ],
          ),
        ),
      ),
    );
  }
}
