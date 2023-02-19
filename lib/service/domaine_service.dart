import 'dart:convert';

import 'package:domaine_nc_mobile/assets/constants.dart';
import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/model/domaine_info.dart';
import 'package:http/http.dart' as http;

class DomaineService {
  static const String _serverUrl = "https://domaine-nc.p.rapidapi.com";
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': '[GIVE ME AN API KEY]',
  };

  static Future<List<DomaineSearchResult>> fetchDomainFromSearch(
      String query) async {
    final response = await http
        .get(
          Uri.parse("$_serverUrl/domaines?startswith=$query"),
          headers: _headers,
        )
        .timeout(timeoutDuration);

    if (response.statusCode == 200) {
      Iterable<dynamic> iterableJson =
          jsonDecode(response.body) as Iterable<dynamic>;
      return List<DomaineSearchResult>.from(
        iterableJson.map((model) =>
            DomaineSearchResult.fromJson(model as Map<String, dynamic>)),
      );
    } else {
      throw Exception('Failed to load Domaines');
    }
  }

  static Future<DomaineInfo> getDomainInfo(
    String name,
    String extension,
  ) async {
    final response = await http
        .get(
          Uri.parse("$_serverUrl/domaines/$name/$extension"),
          headers: _headers,
        )
        .timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return DomaineInfo.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Domaine doesn't exist");
    }
  }
}
