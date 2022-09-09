import 'dart:convert';

import 'package:domaine_nc_mobile/model/domaine.dart';
import 'package:http/http.dart' as http;

class DomaineService {
  static const serverUrl = "http://localhost:8080/domaines";

  static Future<List<DomaineSearchResult>> fetchDomainFromSearch(
      String query) async {
    final response = await http.get(Uri.parse("$serverUrl?startswith=$query"));

    if (response.statusCode == 200) {
      Iterable iterableJson = jsonDecode(response.body);
      return List<DomaineSearchResult>.from(
        iterableJson.map((model) => DomaineSearchResult.fromJson(model)),
      );
    } else {
      throw Exception('Failed to load Domaines');
    }
  }
}
