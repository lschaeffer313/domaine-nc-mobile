import 'dart:convert';

import 'package:domaine_nc_mobile/model/domaine_search_result.dart';
import 'package:domaine_nc_mobile/model/domaine_info.dart';
import 'package:http/http.dart' as http;

class DomaineService {
  static const serverUrl = "http://localhost:8080";

  static Future<List<DomaineSearchResult>> fetchDomainFromSearch(
      String query) async {
    final response =
        await http.get(Uri.parse("$serverUrl/domaines?startswith=$query"));

    if (response.statusCode == 200) {
      Iterable iterableJson = jsonDecode(response.body);
      return List<DomaineSearchResult>.from(
        iterableJson.map((model) => DomaineSearchResult.fromJson(model)),
      );
    } else {
      throw Exception('Failed to load Domaines');
    }
  }

  static Future<DomaineInfo> getDomainInfo(
    String name,
    String extension,
  ) async {
    final response = await http.get(Uri.parse("$serverUrl/$name/$extension"));

    if (response.statusCode == 200) {
      return DomaineInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Domaine doesn't exist");
    }
  }
}
