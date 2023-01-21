import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchBar extends StatelessWidget {
  final idTagHero = "searchbar";
  final hintText = "opt";
  final String extensionNC = ".nc";
  final String regexSpace = r'\s';
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
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(regexSpace)),
        ],
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(
            Icons.search,
          ),
          suffixIcon: GestureDetector(
            child: const Icon(Icons.info_outline_rounded),
            onTap: () =>
                Navigator.pushNamed(context, SearchRoute.aboutPageRoute),
          ),
          suffix: Text(extensionNC),
        ),
        onChanged: callBackOnChanged,
      ),
    );
  }
}
