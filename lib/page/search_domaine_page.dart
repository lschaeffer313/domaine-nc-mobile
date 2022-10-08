import 'dart:async';

import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:domaine_nc_mobile/service/domaine_service.dart';
import 'package:domaine_nc_mobile/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SearchDomainPage extends StatefulWidget {
  const SearchDomainPage({super.key});

  final edgeInsets = const EdgeInsets.symmetric(horizontal: 20);
  final idTagHero = "searchbar";

  @override
  State<SearchDomainPage> createState() => _SearchDomainPageState();
}

class _SearchDomainPageState extends State<SearchDomainPage> {
  Timer? _debounce;
  var _searchResults = List<DomaineSearchResult>.empty();
  final _searchController = TextEditingController();
  var _isLoading = false;

  void _searchDomainChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query.isNotEmpty) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });
      }
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        var list = await DomaineService.fetchDomainFromSearch(query);
        setState(() {
          _searchResults = list;
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _searchResults.clear();
        _isLoading = false;
      });
    }
  }

  Widget _displayDomainResult() {
    if (_searchResults.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 10.0,
          child: ListView.builder(
            itemCount: _searchResults.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SearchRoute.domaineInfoRoute,
                    arguments: _searchResults[index],
                  );
                },
                leading: const Icon(
                  Icons.public,
                  size: 40,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    _searchResults[index].name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "Extension: ${_searchResults[index].extension}",
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          _searchController.value.text.isEmpty ? "" : "Aucun Résultat",
        ),
      );
    }
  }

  Widget _skeletonLoader() {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 8),
      child: SkeletonListView(
        item: SkeletonListTile(
          hasLeading: true,
          hasSubtitle: true,
          titleStyle: const SkeletonLineStyle(
            maxLength: 200,
            minLength: 100,
            randomLength: true,
          ),
          subtitleStyle: const SkeletonLineStyle(
            width: 100,
          ),
          leadingStyle: const SkeletonAvatarStyle(
            shape: BoxShape.circle,
            width: 44,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _isLoading ? _skeletonLoader() : _displayDomainResult(),
              ),
              Hero(
                tag: widget.idTagHero,
                child: Material(
                  color: Colors.grey,
                  child: SearchBar(
                    isAutoFocus: true,
                    readOnly: false,
                    searchController: _searchController,
                    callBackOnChanged: _searchDomainChanged,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
