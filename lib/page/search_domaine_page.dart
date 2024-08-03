import 'dart:async';

import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/routes/search_route.dart';
import 'package:domaine_nc_mobile/service/domaine_service.dart';
import 'package:domaine_nc_mobile/utils/error_utils.dart';
import 'package:domaine_nc_mobile/widget/search_bar_domaine.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = "";
  String _oldQuery = "";

  void _queryChanged(String query) {
    // Prevent from sending request when taping space
    if (_oldQuery == query) {
      return;
    } else {
      _oldQuery = query;
    }
    _isError = false;
    _errorMessage = "";
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (query.isNotEmpty) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });
      }
      _debounce = Timer(
        const Duration(milliseconds: 500),
        () => _handleFetchDomain(query),
      );
    } else {
      setState(() {
        if (_searchResults.isNotEmpty) {
          _searchResults.clear();
        }
        _isLoading = false;
      });
    }
  }

  void _handleFetchDomain(String query) async {
    try {
      var list = await DomaineService.fetchDomainFromSearch(query);
      setState(() {
        _searchResults = list;
        _isLoading = false;
      });
    } on Exception catch (err) {
      setState(() {
        _isError = true;
        _errorMessage = errorMessageType(err);
        _isLoading = false;
      });
    }
  }

  Widget _handleResponse(BuildContext context) {
    if (_isError) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(child: Text(_errorMessage)),
      );
    } else {
      return _displayDomainResult(context);
    }
  }

  Widget _displayDomainResult(BuildContext context) {
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
          "Aucun Résultat",
        ),
      );
    }
  }

  Widget _skeletonLoader() {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Color.fromARGB(255, 196, 179, 23),
        highlightColor: Colors.white,
        duration: Duration(seconds: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 10.0,
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.public,
                  size: 40,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "Placeholder.nc",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "This is a placeholder for domain",
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _isLoading ? _skeletonLoader() : _handleResponse(context),
            ),
            Hero(
              tag: widget.idTagHero,
              child: Material(
                color: Colors.transparent,
                child: SearchBarDomaine(
                    isAutoFocus: true,
                    readOnly: false,
                    searchController: _searchController,
                    callBackOnChanged: _queryChanged),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
