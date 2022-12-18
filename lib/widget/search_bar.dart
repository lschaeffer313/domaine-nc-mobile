import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final idTagHero = "searchbar";
  final bool isAutoFocus;
  final bool readOnly;
  final VoidCallback? callbackOnTap;
  final Function(String)? callBackOnChanged;
  final TextEditingController? searchController;

  const SearchBar({
    super.key,
    this.callbackOnTap,
    this.callBackOnChanged,
    this.searchController,
    required this.isAutoFocus,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onTap: callbackOnTap,
        controller: searchController,
        autofocus: isAutoFocus,
        readOnly: readOnly,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: GestureDetector(
            child: const Icon(Icons.info_outline_rounded),
            onTap:() => Navigator.pushNamed(context, SearchRoute.aboutPageRoute),
          ),
          suffix: const Text(".nc"),
        ),
        onChanged: callBackOnChanged,
      ),
    );
  }
}
