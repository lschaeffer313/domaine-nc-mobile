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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
          ),
          suffix: Text(".nc"),
        ),
        onChanged: callBackOnChanged,
      ),
    );
  }
}
