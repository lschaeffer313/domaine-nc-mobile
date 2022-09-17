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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffix: Text(".nc"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.yellow),
          ),
          filled: true,
          fillColor: Colors.grey,
        ),
        onChanged: callBackOnChanged,
      ),
    );
  }
}
